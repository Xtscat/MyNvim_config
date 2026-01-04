local M = {}
local Map = require("utils.map").with_prefix("Window")

function M.edgy_config()
    require("edgy").setup({
        animate = { enabled = false },
        close_when_all_hidden = true,
        exit_when_last = true,
        wo = { winbar = false },
        left = {
            {
                ft = "neo-tree",
                pinned = true,
                collapsed = false,
                size = { height = 0.5, width = 0.12 },
                open = "Neotree show"
            },
            {
                ft = "Outline",
                pinned = true,
                collapsed = false,
                size = { height = 0.5, width = 0.12 },
                open = "Outline"
            }
        },
        bottom = {
            {
                ft = 'toggleterm',
                size = { height = 0.3 },
                filter = function(_, win)
                    local cfg = vim.api.nvim_win_get_config(win)
                    local term = require("toggleterm.terminal").get(1)
                    return cfg.relative == "" and term.direction == "horizontal"
                end
            },
        },
        right = {
            {
                ft = "opencode_terminal",
                size = { width = 0.3 },
                collapsed = false,
                open = "OpenCode",
            },
            {
                ft = "trouble",
                size = { width = 0.3 },
                collapsed = false,
                open = "Trouble diagnostics toggle",
            }
        }
    })
end

function M.winpick_config()
    require("nvim_winpick").setup({
        selection_chars = "FJDKSLA;CMRUEIWOQP",
        filter_rules = {
            bo = {
                filetype = { "notify", "snacks_notif" }
            },
        },
    })
end

function M.toggleterm_config()
    require("toggleterm").setup()
end

-- function M.snacks_config()
--     require("snacks").setup({
--         input = { enabled = true },
--         picker = { enabled = true },
--         terminal = { enabled = true }
--     })
-- end

function M.toggleterm_keymaps()
    Map.nmap('<leader>T', '<cmd>ToggleTerm<CR>', "Open Toggleterm terminal")
end

function M.winpick_keymap()
    Map.nmap(
        "<leader>fw",
        function()
            require("nvim_winpick").pick_focus_window()
        end,
        "[F]ind[W]indow"
    )
end

return M
