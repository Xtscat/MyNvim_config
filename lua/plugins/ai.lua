-- Helper function to check if CodeCompanion chat window is currently open
local function is_codecompanion_open()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        -- Check if the window is valid before getting the buffer
        if vim.api.nvim_win_is_valid(winid) then
            local bufid = vim.api.nvim_win_get_buf(winid)
            -- Check if the buffer is valid and loaded before getting options
            if vim.api.nvim_buf_is_valid(bufid) and vim.api.nvim_buf_is_loaded(bufid) then
                -- Use pcall for safety when getting the option
                local success, ft = pcall(vim.api.nvim_buf_get_option, bufid, 'filetype')
                if success and ft == 'codecompanion' then
                    return true -- Found the CodeCompanion window
                end
            end
        end
    end
    return false -- CodeCompanion window not found
end
-- Modified function to manage Aerial based on CodeCompanion state
local function ToggleChatManageAerial()
    if is_codecompanion_open() then
        -- CodeCompanion is currently OPEN, so we are about to CLOSE it.
        -- Close CodeCompanion first
        pcall(vim.cmd, 'CodeCompanionChat Toggle')
        -- THEN open Aerial
        -- Use AerialOpen to ensure it opens, even if it was already open (though toggle might work too)
        pcall(vim.cmd, 'AerialOpen')
        vim.notify("CodeCompanion closed, Aerial opened.", vim.log.levels.INFO, { title = "Window Manager" })
    else
        -- CodeCompanion is currently CLOSED, so we are about to OPEN it.
        -- Close Aerial first
        pcall(vim.cmd, 'AerialClose')
        -- THEN open CodeCompanion
        pcall(vim.cmd, 'CodeCompanionChat Toggle')
        vim.notify("Aerial closed, CodeCompanion opened.", vim.log.levels.INFO, { title = "Window Manager" })
    end
    -- Optional: Try to focus the main window after toggling.
    -- You might need to adjust this depending on your window layout and desired focus.
    -- vim.cmd('wincmd p')
end

--- 切换并显示模型及其倍率信息
local function switch_chat_model()
    -- 1. 这是您提供的模型列表，已经整合进来
    local models = {
        -- GPT
        { name = "gpt-4.1-2025-04-14",        magnification = "0x" },
        { name = "gpt-4o-2024-11-20",         magnification = "0x" },
        { name = "o1-2021-12-17",             magnification = "10x" },
        { name = "o3-mini-2025-01-31",        magnification = "0.33x" },
        { name = "o4-mini-2025-04-06",        magnification = "0.33x" },
        -- Claude
        { name = "claude-3.5-sonnet",         magnification = "1x" },
        { name = "claude-3.7-sonnet",         magnification = "1x" },
        { name = "claude-3.7-sonnet-thought", magnification = "1.25x" },
        { name = "claude-sonnet-4",           magnification = "1x" },
        -- Gemini
        { name = "gemini-2.0-flash-001",      magnification = "0.25x" },
        { name = "gemini-2.5-pro",            magnification = "1x" },
    }

    -- 2. 使用 vim.ui.select 创建选择界面
    vim.ui.select(models, {
        prompt = "选择一个模型:",
        -- 3. 自定义每个选项的显示格式
        format_item = function(item)
            return string.format("%-30s (倍率: %s)", item.name, item.magnification or "N/A")
        end,
    }, function(choice)
        -- 4. 用户选择后的回调函数
        if not choice then
            vim.notify("取消选择", vim.log.levels.INFO)
            return
        end

        -- 修正: 调用 setup 函数来更新配置
        require('codecompanion').setup({
            strategies = {
                chat = {
                    adapter = {
                        model = choice.name
                    }
                }
            }
        })

        vim.notify("已切换到模型: " .. choice.name, vim.log.levels.INFO)
    end)
end

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
--
-- 在 chat buffer 里面使用 'cm' 打开切换模型窗口
return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "zbirenbaum/copilot.lua",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.diff"
    },
    -- 在普通模式下，按下 <leader>o 来切换 CodeCompanion 聊天缓冲区, 同时自动关闭和打开 Outline
    vim.keymap.set('n', '<leader>o', ToggleChatManageAerial,
        { silent = true, desc = "Toggle CodeCompanion & Outline" }),
    -- 在普通模式和可视模式下，按下 <leader>m 来执行 CodeCompanion 命令
    vim.keymap.set({ "n", "v" }, "<Leader>m", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true }),
    vim.keymap.set('n', '<leader>cm', switch_chat_model, { silent = true, desc = "Switch CodeCompanion Chat Model" }),

    config = function()
        require('copilot').setup({})
        require('codecompanion').setup({
            strategies = {
                chat = {
                    adapter = {
                        name = 'copilot',
                        model = 'gemini-2.5-pro'
                    },
                    keymaps = {
                        send = {
                            modes = { n = "<leader>k", i = "<leader>k" },
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
                opts = {
                    -- show_defaults 会导致copilot不能正常工作
                    show_defaults = false,
                    show_model_choices = true
                    -- log_level = "DEBUG",
                },
            },
            opts = {
                language = "Chinese"
            }
        })
    end
}
