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

return M
