return {
    -- 插件 1: Toggleterm (精简配置)
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require('toggleterm').setup({
                -- 当 cmake-tools 调用时，默认在底部打开
                direction = 'horizontal',
                -- 任务结束后，保持窗口打开
                close_on_exit = false,
                -- [关键] 内置的关闭快捷键：在终端窗口的普通模式下按 'q' 即可关闭
                terminal_mappings = function(term)
                    -- 返回一个包含快捷键定义的表格
                    return {
                        -- 将 'q' 键映射为关闭当前终端的命令
                        { 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true, buffer = term.bufnr } },
                    }
                end
            })
        end
    },

    -- 插件 2: CMake Tools (直接调用 Toggleterm)
    {
        'Civitasv/cmake-tools.nvim',
        -- [关键] 不再需要 overseer
        dependencies = {
            "nvim-lua/plenary.nvim",
            'akinsho/toggleterm.nvim',
        },
        config = function()
            require("cmake-tools").setup({
                -- 基础配置
                cmake_command = "cmake",
                cmake_regenerate_on_save = true,
                cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
                cmake_build_directory = "build/${variant:buildType}",

                -- [关键] Executor (编译) 直接使用 toggleterm
                cmake_executor = {
                    name = "toggleterm",
                    opts = {
                        direction = "horizontal", -- 保证在底部
                        singleton = true,         -- [关键] 保证复用同一个窗口
                        close_on_exit = false,
                    },
                },

                -- [关键] Runner (运行) 也直接使用 toggleterm
                cmake_runner = {
                    name = "toggleterm",
                    opts = {
                        direction = "horizontal", -- 保证在底部
                        singleton = true,         -- [关键] 保证复用同一个窗口
                        close_on_exit = false,
                    },
                },
            })
        end
    }
}
