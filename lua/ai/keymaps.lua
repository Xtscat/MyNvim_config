-- ai/keymaps.lua

local M = {}

local nmap = function(keys, func, desc)
    if desc then
        desc = 'AI: ' .. desc
    end
    vim.keymap.set('n', keys, func, { desc = desc })
end


function M.opencode_keymaps()
    local opencode = require("opencode")
    vim.api.nvim_create_user_command("OpenCode", function() opencode.toggle() end, {})

    nmap('<leader>o', '<cmd>OpenCode<CR>', "OpenCode Toggle")

    nmap(
        '<leader>hi',
        function()
            opencode.ask("@this", { submit = true })
        end,
        "Ask opencode"
    )

    nmap(
        '<leader>hs',
        function()
            opencode.select()
        end,
        "Execute opencode action"
    )
end

return M
