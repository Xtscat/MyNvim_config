-- modules/build/spec.lua
--
-- Build tooling (CMake). Language servers live in code/lsp.

local C = "modules.build.config"

return {
    {
        "Civitasv/cmake-tools.nvim",
        cmd = {
            "CMakeGenerate",
            "CMakeBuild",
            "CMakeRun",
            "CMakeCloseExecutor",
            "CMakeCloseRunner",
            "CMakeSelectBuildType",
            "CMakeSelectBuildTarget",
            "CMakeSelectLaunchTarget",
            "CMakeSelectConfigurePreset",
            "CMakeSelectBuildPreset",
            "CMakeSelectLaunchPreset",
        },
        config = function() require(C).cmake_tools() end,
    },
}
