#pragma once

#include <filesystem>

int runCanonicalRequest(
    const std::filesystem::path& requestPath,
    const std::filesystem::path& cOutputPath,
    const std::filesystem::path& hastOutputPath,
    const std::filesystem::path& resultOutputPath);
