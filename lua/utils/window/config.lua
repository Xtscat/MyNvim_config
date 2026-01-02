-- utils/window/config.lua

local M = {}

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

function M.snacks_config()
    require("snacks").setup({
        input = { enabled = true },
        picker = { enabled = true },
        terminal = { enabled = true }
    })
end

return M
