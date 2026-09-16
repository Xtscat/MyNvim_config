-- modules/build/keys.lua

local Map = require("utils.map").with_prefix("CMake")
local M = {}

function M.register()
    Map.nmap("<leader>Cc", "<cmd>CMakeClean<CR>", "CMake Clean")
    Map.nmap("<leader>Cg", "<cmd>CMakeGenerate<CR>", "CMake Generate")
    Map.nmap("<leader>Cb", "<cmd>CMakeQuickBuild<CR>", "CMake Quick Build")
    Map.nmap("<leader>CB", "<cmd>CMakeBuild<CR>", "CMake Build")
    Map.nmap("<leader>Cr", "<cmd>CMakeRun<CR>", "CMake Run")
    Map.nmap("<leader>Ct", "<cmd>CMakeSelectBuildTarget<CR>", "CMake Select Build Target")
    Map.nmap("<leader>CT", "<cmd>CMakeSelectLaunchTarget<CR>", "CMake Select Launch Target")
    Map.nmap("<leader>Cp", "<cmd>CMakeSelectConfigurePreset<CR>", "CMake Select Configure Preset")
    Map.nmap("<leader>CP", "<cmd>CMakeSelectBuildPreset<CR>", "CMake Select Build Preset")
end

return M
