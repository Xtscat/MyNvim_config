-- configs/cmake.lua

local M = {}
local Map = require("utils.map").with_prefix("CMake")

function M.cmake_tools_config()
    require("cmake-tools").setup({
        cmake_use_preset = true,
        cmake_regenerate_on_save = false,
        cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_compile_commands_options = {
            action = "soft_link",
            target = vim.loop.cwd(),
        },
        cmake_dap_configuration = {
            name = "cpp",
            type = "codelldb",
            request = "launch",
            stopOnEntry = false,
            runInTerminal = true,
            console = "integratedTerminal",
        },
        cmake_executor = {
            name = "toggleterm",
            opts = {
                direction = "horizontal",
                close_on_exit = false,
                auto_scroll = true,
                singleton = true,
            },
        },
        cmake_runner = {
            name = "toggleterm",
            opts = {
                direction = "horizontal",
                close_on_exit = false,
                auto_scroll = true,
                singleton = true,
            },
        },
    })
end

function M.cmake_tools_keymaps()
    Map.nmap("<leader>cc", "<cmd>CMakeClean<CR>", "CMake Clean")
    Map.nmap("<leader>cg", "<cmd>CMakeGenerate<CR>", "CMake Generate")
    Map.nmap("<leader>cb", "<cmd>CMakeQuickBuild<CR>", "CMake Quick Build")
    Map.nmap("<leader>cB", "<cmd>CMakeBuild<CR>", "CMake Build")
    Map.nmap("<leader>cr", "<cmd>CMakeRun<CR>", "CMake Run")
    Map.nmap("<leader>cd", "<cmd>CMakeDebug<CR>", "CMake Debug")
    Map.nmap("<leader>ct", "<cmd>CMakeSelectBuildTarget<CR>", "CMake Select Build Target")
    Map.nmap("<leader>cT", "<cmd>CMakeSelectLaunchTarget<CR>", "CMake Select Launch Target")
    Map.nmap("<leader>cp", "<cmd>CMakeSelectConfigurePreset<CR>", "CMake Select Configure Preset")
    Map.nmap("<leader>cP", "<cmd>CMakeSelectBuildPreset<CR>", "CMake Select Build Preset")
end

return M
