#pragma once

#include <cstdlib>

namespace helix {

inline bool pipelineDebugEnabled() noexcept {
    return std::getenv("HELIX_PIPELINE_DEBUG") != nullptr;
}

inline bool scfDebugEnabled() noexcept {
    return pipelineDebugEnabled() ||
           std::getenv("HELIX_SCF_SPIKE_DEBUG") != nullptr;
}

} // namespace helix
