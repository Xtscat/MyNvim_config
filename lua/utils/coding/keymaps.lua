-- utils/coding/keymaps.lua

local M = {}

local nmap = function(keys, func, desc)
    if desc then
        desc = 'Coding: ' .. desc
    end
    vim.keymap.set('n', keys, func, { desc = desc })
end

function M.code_runner_keymaps()
    nmap("<leader>rc", "<cmd>RunCode<CR>", "[R]un[C]ode")
end

return M
