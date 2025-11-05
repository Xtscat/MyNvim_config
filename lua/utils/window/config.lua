-- utils/window/config.lua

local M = {}

function M.window_picker_config()
    require("window-picker").setup({
        filter_rules = {
            include_current_win = true,
            bo = {
                filetype = { "fidget" }
            }
        }
    })
end

return M
