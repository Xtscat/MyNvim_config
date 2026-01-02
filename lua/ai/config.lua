-- ai/config.lua

local M = {}

function M.opencode_config()
    vim.g.opencode_opts = {
        provider = {
            enabled = "snacks",
            snacks = {

            }
        },
        eventes = {
            reload = true
        },
        statusline = true,
    }
    vim.o.autoread = true
end

return M
