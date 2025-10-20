--[[ 内置指令：
* Variables: Variables, accessed via #, contain data about the present state of Neovim
    * #buffer: Shares the current buffer's code.
    * #lsp: Shares LSP information and code for the current buffer
    * #viewpoint: Shares the buffers and lines that you see in the Neovim viewport

* Slash Commands: Slash commands, accessed via /, run commands to insert additional context into the chat buffer
    * /buffer: Insert open buffers
    * /fetch: Insert URL contents
    * /file: Insert a file
    * /help: Insert content from help tags
    * /now: Insert the current date and time
    * /symbols: Insert symbols from a selected file
    * /terminal: Insert terminal output

* Agents / Tools: Tools, accessed via @, allow the LLM to function as an agent and carry out actions
    * @cmd_runner: The LLM will run shell commands (subject to approval)
    * @editor: The LLM will edit code in a Neovim buffer
    * @files: The LLM will can work with files on the file system (subject to approval)
    * @full_stack_dev: Contains the cmd_runner, editor and files tools.

* Inline Assisant: The inline assistant enables an LLM to write code directly into a Neovim buffer.
    * #buffer: shares the contents of the current buffer
    * #chat: shares the LLM's messages from the last chat buffer
    * /commit: Generate a commit message (visual mode and select some code)
    * /explain: Explain how selected code in a buffer works (visual mode and select some code)
    * /fix: Fix the selected code (visual mode and select some code)
    * /lsp: Explain the LSP diagnostics for the selected code (visual mode and select some code)
    * /tests: Generate unit tests for selected code (visual mode and select some code)
-- ]]

---------------------------------------------------
-- 在 chat buffer 里面使用 'ga' 打开切换模型窗口 --
---------------------------------------------------
return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "zbirenbaum/copilot.lua",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.diff"
    },
    -- 在普通模式下，按下 <leader>o 来切换 CodeCompanion 聊天
    vim.keymap.set('n', '<leader>o', '<cmd>CodeCompanionChat Toggle<CR>', { desc = 'Open CodeCompanion Chat' }),
    -- 在普通模式和可视模式下，按下 <leader>m 来执行 CodeCompanion 命令
    vim.keymap.set({ "n", "v" }, "<Leader>m", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true }),

    config = function()
        require('copilot').setup({})
        require('codecompanion').setup({
            strategies = {
                chat = {
                    adapter = {
                        name = 'copilot',
                        model = 'gpt-5-mini'
                    },
                    keymaps = {
                        send = {
                            modes = { n = "<c-k>", i = "<c-k>" },
                        },
                        close = {
                            modes = { n = "<leader>xo", i = "<leder>xo" },
                        },
                    },
                },
                inline = {
                    adapter = {
                        name = 'copilot',
                        model = 'gemini-2.5-pro'
                    },
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
                    adapter = {
                        name = 'copilot',
                        model = 'gpt-4.1-2025-04-14'
                    },
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
                http = {
                    opts = {
                        -- show_defaults 会导致copilot不能正常工作
                        show_defaults = false,
                        show_model_choices = true,
                        -- log_level = "DEBUG",
                        language = "Chinese"
                    },

                }
            },
        })
    end
}
