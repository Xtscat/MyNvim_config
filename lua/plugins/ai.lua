local function ToggleChatAndOutline()
    -- 切换 Outline (直接调用你的 Toggle 命令)
    pcall(vim.cmd, 'Outline')
    -- 切换 CodeCompanion Chat
    pcall(vim.cmd, 'CodeCompanionChat Toggle')
    -- 可选: 尝试将焦点跳回之前的窗口 (如果需要)
    -- vim.cmd('wincmd p')
end

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.diff"
    },
    -- 在普通模式下，按下 <leader>o 来切换 CodeCompanion 聊天缓冲区, 同时自动关闭和打开 Outline
    vim.keymap.set('n', '<leader>o', ToggleChatAndOutline, { silent = true, desc = "Toggle CodeCompanion & Outline" }),
    -- 在普通模式和可视模式下，按下 <leader>m 来执行 CodeCompanion 命令
    vim.keymap.set({ "n", "v" }, "<Leader>m", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true }),
    config = function()
        require('codecompanion').setup({
            strategies = {
                chat = {
                    adapter = "gemini",
                    keymaps = {
                        send = {
                            modes = { n = "<C-s>", i = "<C-s>" },
                        },
                        close = {
                            modes = { n = "<C-c>", i = "<C-c>" },
                        },
                    },
                },
                inline = {
                    adapter = "gemini",
                    keymaps = {
                        accept_change = {
                            modes = { n = "ga" },
                            description = "Accept the suggested change",
                        },
                        reject_change = {
                            modes = { n = "gr" },
                            description = "Reject the suggested change",
                        },
                    },
                },
                cmd = {
                    adapter = "gemini"
                },
            },
            display = {
                chat = {
                    window = {
                        position = "right",
                        width = 0.3
                    }
                }
            },
            adapters = {
                gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        env = {
                            api_key = "GEMINI_API_KEY"
                        },
                        schema = { model = { default = "gemini-2.5-pro-exp-03-25" } }
                    })
                end,
            },
            opts = {
                language = "Chinese"
            }
        })
    end
}
