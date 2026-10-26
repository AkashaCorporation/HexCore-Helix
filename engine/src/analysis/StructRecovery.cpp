/// @file StructRecovery.cpp
/// @brief Implementation of struct type recovery from memory access patterns.
///
/// Groups memory accesses by base pointer, then constructs struct layouts
/// from distinct-offset accesses.  Detects arrays (regular stride with
/// identical element types), union candidates (overlapping fields), and
/// inserts padding to fill gaps.

#include "helix/analysis/StructRecovery.h"

#include <algorithm>
#include <cstdint>
#include <format>
#include <map>
#include <set>

namespace helix {

// ═══════════════════════════════════════════════════════════════════════════════
// Public API
// ═══════════════════════════════════════════════════════════════════════════════

void StructRecoveryAnalyzer::addAccess(const AccessPattern& access) {
    accesses_.push_back(access);
}

std::vector<RecoveredStruct> StructRecoveryAnalyzer::analyze() {
    // Group accesses by base_var_id.
    std::map<uint32_t, std::vector<AccessPattern>> groups;
    for (const auto& access : accesses_)
        groups[access.base_var_id].push_back(access);

    std::vector<RecoveredStruct> results;
    unsigned structCounter = 0;

    for (auto& [baseVar, group] : groups) {
        // Count distinct offsets.
        std::set<int64_t> distinctOffsets;
        for (const auto& a : group)
            distinctOffsets.insert(a.offset);

        // Only build a struct if there are 2+ distinct offsets.
        if (distinctOffsets.size() < 2)
            continue;

        auto recovered = buildStruct(baseVar, group);
        recovered.name = std::format("auto_struct_{}", structCounter++);

        detectArrays(recovered);
        insertPadding(recovered);

        results.push_back(std::move(recovered));
    }

    return results;
}

void StructRecoveryAnalyzer::reset() {
    accesses_.clear();
}

// ═══════════════════════════════════════════════════════════════════════════════
// Private Implementation
// ═══════════════════════════════════════════════════════════════════════════════

RecoveredStruct StructRecoveryAnalyzer::buildStruct(
    uint32_t base_var,
    const std::vector<AccessPattern>& group) {

    RecoveredStruct result;
    result.total_size = 0;
    result.alignment = 1;
    result.has_overlaps = false;
    result.base_var_id = base_var;

    // Group accesses by offset to merge into fields.
    std::map<int64_t, std::vector<const AccessPattern*>> byOffset;
    for (const auto& access : group)
        byOffset[access.offset].push_back(&access);

    for (auto& [offset, accesses] : byOffset) {
        if (offset < 0)
            continue;  // Negative offsets are unusual; skip for safety.

        RecoveredField field;
        field.offset = static_cast<unsigned>(offset);
        field.access_count = static_cast<unsigned>(accesses.size());

        // Check if any access at this offset is a dynamic array pattern.
        bool hasDynamicArray = false;
        int64_t arrayStride = 0;
        for (const auto* a : accesses) {
            if (a->is_dynamic_array && a->stride > 0) {
                hasDynamicArray = true;
                arrayStride = a->stride;
                break;
            }
        }

        // Determine field size: use the maximum access width seen at this offset.
        unsigned maxWidth = 0;
        for (const auto* a : accesses) {
            if (a->access_width > maxWidth)
                maxWidth = a->access_width;
        }

        // Determine field type: prefer the most specific type hint.
        // If multiple accesses have type hints, use meet() to combine them.
        HelixTypeInfo fieldType;
        bool hasTypeHint = false;
        for (const auto* a : accesses) {
            if (a->type_hint.isResolved()) {
                if (!hasTypeHint) {
                    fieldType = a->type_hint;
                    hasTypeHint = true;
                } else {
                    fieldType = HelixTypeInfo::meet(fieldType, a->type_hint);
                }
            }
        }

        if (hasDynamicArray) {
            // Dynamic array: *(base + index * stride) at this offset.
            unsigned elemSize = (arrayStride > 0)
                ? static_cast<unsigned>(arrayStride) : maxWidth;

            // Element type from stride width.
            HelixTypeInfo elemType;
            if (hasTypeHint) {
                elemType = fieldType;
            } else if (elemSize == 1) {
                // stride=1 byte access → likely char/string
                elemType = HelixTypeInfo::makeInt(8, false);
            } else {
                switch (elemSize) {
                case 2: elemType = HelixTypeInfo::makeInt(16, true); break;
                case 4: elemType = HelixTypeInfo::makeInt(32, true); break;
                case 8: elemType = HelixTypeInfo::makeInt(64, true); break;
                default: elemType = HelixTypeInfo::makeInt(elemSize * 8, true); break;
                }
            }

            // Unknown length (dynamic) → 0.
            field.type = HelixTypeInfo::makeArray(elemType, /*length=*/0);
            field.size = elemSize;  // Minimum known element size.

            // Name: "array_<offset>" or "str_<offset>" for byte-stride.
            if (elemSize == 1)
                field.name = std::format("str_{:x}", field.offset);
            else
                field.name = std::format("array_{:x}", field.offset);
        } else {
            // Regular constant-offset field.
            field.size = maxWidth;

            if (!hasTypeHint) {
                switch (maxWidth) {
                case 1: fieldType = HelixTypeInfo::makeInt(8, false); break;
                case 2: fieldType = HelixTypeInfo::makeInt(16, true); break;
                case 4: fieldType = HelixTypeInfo::makeInt(32, true); break;
                case 8: fieldType = HelixTypeInfo::makeInt(64, true); break;
                default: fieldType = HelixTypeInfo::makeUnknown(); break;
                }
            }
            field.type = fieldType;
            field.name = std::format("field_{:x}", field.offset);
        }

        result.fields.push_back(std::move(field));
    }

    // Sort fields by offset.
    std::sort(result.fields.begin(), result.fields.end(),
              [](const RecoveredField& a, const RecoveredField& b) {
                  return a.offset < b.offset;
              });

    // Detect overlapping fields (union candidates).
    for (size_t i = 0; i + 1 < result.fields.size(); ++i) {
        unsigned endI = result.fields[i].offset + result.fields[i].size;
        unsigned startNext = result.fields[i + 1].offset;
        if (endI > startNext) {
            result.has_overlaps = true;
            break;
        }
    }

    // Compute total size: max(field.offset + field.size) across all fields.
    for (const auto& f : result.fields) {
        unsigned end = f.offset + f.size;
        if (end > result.total_size)
            result.total_size = end;
    }

    // Infer alignment from the largest field size (power of 2, max 16).
    unsigned maxFieldSize = 0;
    for (const auto& f : result.fields) {
        if (f.size > maxFieldSize)
            maxFieldSize = f.size;
    }

    // Round up to the nearest power of 2.
    result.alignment = 1;
    while (result.alignment < maxFieldSize && result.alignment < 16)
        result.alignment *= 2;

    // Round total_size up to alignment.
    if (result.alignment > 0) {
        result.total_size =
            (result.total_size + result.alignment - 1) / result.alignment *
            result.alignment;
    }

    return result;
}

void StructRecoveryAnalyzer::detectArrays(RecoveredStruct& s) {
    // Look for sequences of 3+ consecutive fields with the same size and type
    // at regular stride intervals.
    if (s.fields.size() < 3)
        return;

    // We do not actually merge them into array fields here — that would
    // require restructuring the field list.  Instead, we annotate fields
    // by appending "[N]" to the name of the first element in a detected
    // array run.
    //
    // Detection: scan for runs where:
    //   field[i+1].offset - field[i].offset == field[i].size (stride)
    //   field[i+1].size == field[i].size
    //   field[i+1].type == field[i].type (or both unknown)

    size_t i = 0;
    while (i < s.fields.size()) {
        unsigned stride = s.fields[i].size;
        if (stride == 0) {
            ++i;
            continue;
        }

        // Count consecutive fields with the same stride and size.
        size_t runLen = 1;
        for (size_t j = i + 1; j < s.fields.size(); ++j) {
            unsigned expectedOffset =
                s.fields[i].offset + static_cast<unsigned>(runLen) * stride;
            if (s.fields[j].offset == expectedOffset &&
                s.fields[j].size == stride) {
                ++runLen;
            } else {
                break;
            }
        }

        if (runLen >= 3) {
            // Annotate the first field as an array.
            s.fields[i].name =
                std::format("{}[{}]", s.fields[i].name, runLen);

            // Update type to array.
            s.fields[i].type =
                HelixTypeInfo::makeArray(s.fields[i].type, runLen);
            s.fields[i].size = stride * static_cast<unsigned>(runLen);
            s.fields[i].access_count = 0;
            for (size_t j = i; j < i + runLen; ++j)
                s.fields[i].access_count += s.fields[j].access_count;

            // Remove the subsequent array elements (they are folded into
            // the first field).
            s.fields.erase(s.fields.begin() + static_cast<ptrdiff_t>(i + 1),
                           s.fields.begin() + static_cast<ptrdiff_t>(i + runLen));
        }

        ++i;
    }
}

void StructRecoveryAnalyzer::insertPadding(RecoveredStruct& s) {
    if (s.fields.empty() || s.has_overlaps)
        return;  // Don't insert padding for union candidates.

    std::vector<RecoveredField> withPadding;

    unsigned currentOffset = 0;
    for (const auto& field : s.fields) {
        if (field.offset > currentOffset) {
            // Insert padding to fill the gap.
            RecoveredField pad;
            pad.name = std::format("_pad_{:x}", currentOffset);
            pad.offset = currentOffset;
            pad.size = field.offset - currentOffset;
            pad.type = HelixTypeInfo::makeInt(8, false);  // uint8_t padding
            pad.access_count = 0;
            withPadding.push_back(std::move(pad));
        }
        withPadding.push_back(field);
        currentOffset = field.offset + field.size;
    }

    // Trailing padding to reach total_size.
    if (currentOffset < s.total_size) {
        RecoveredField pad;
        pad.name = std::format("_pad_{:x}", currentOffset);
        pad.offset = currentOffset;
        pad.size = s.total_size - currentOffset;
        pad.type = HelixTypeInfo::makeInt(8, false);
        pad.access_count = 0;
        withPadding.push_back(std::move(pad));
    }

    s.fields = std::move(withPadding);
}

} // namespace helix
