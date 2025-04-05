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

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.diff"
    },
    -- 在普通模式下，按下 <leader>o 来切换 CodeCompanion 聊天缓冲区, 同时自动关闭和打开 Outline
    vim.keymap.set('n', '<leader>o', ToggleChatManageAerial,
        { silent = true, desc = "Toggle CodeCompanion & Outline" }),
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
