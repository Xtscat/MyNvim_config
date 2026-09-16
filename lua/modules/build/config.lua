-- modules/build/config.lua
--
-- cmake-tools: build/run CMake projects. The executor and runner are both
-- toggleterm so builds show up in the same bottom dock managed by edgy.

local M = {}

function M.cmake_tools()
    require("cmake-tools").setup({
        cmake_use_preset = true,          -- read CMakePresets.json
        cmake_regenerate_on_save = false, -- don't regenerate on every write
        -- ask CMake to emit compile_commands.json (used by clice/clangd)
        cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
        cmake_compile_commands_options = {
            action = "soft_link",       -- symlink compile_commands.json into the cwd
            target = vim.fn.getcwd(),
        },
        -- run the build inside a toggleterm
        cmake_executor = {
            name = "toggleterm",
            opts = {
                direction = "horizontal",
                close_on_exit = false,
                auto_scroll = true,
                singleton = true,
            },
        },
        -- run the built program inside a toggleterm
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

return M
