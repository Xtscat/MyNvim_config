local M = {}
local Map = require("utils.map").with_prefix("AI")

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

function M.opencode_keymaps()
    local opencode = require("opencode")
    vim.api.nvim_create_user_command("OpenCode", function() opencode.toggle() end, {})

    Map.nmap('<leader>o', '<cmd>OpenCode<CR>', "OpenCode Toggle")
    Map.nmap(
        '<leader>hi',
        function()
            opencode.ask("@this", { submit = true })
        end,
        "Ask opencode"
    )
    Map.nmap(
        '<leader>hs',
        function()
            opencode.select()
        end,
        "Execute opencode action"
    )
end

return M
