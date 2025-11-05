-- ai/keymaps.lua

local M = {}

local nmap = function(keys, func, desc)
    if desc then
        desc = 'Navigation: ' .. desc
    end
    vim.keymap.set('n', keys, func, { desc = desc })
end

function M.codecompanion_keymaps()
    nmap('<leader>o', '<cmd>CodeCompanionChat Toggle<CR>', "CodeCompanionChat Toggle")
    nmap('<leader>m', '<cmd>CodeCompanion<CR>', "CodeCompanion Toggle")
end

return M
