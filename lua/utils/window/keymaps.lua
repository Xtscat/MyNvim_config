-- utils/window/keymaps.lua

local M = {}

local nmap = function(keys, func, desc)
    if desc then
        desc = 'Window: ' .. desc
    end
    vim.keymap.set('n', keys, func, { desc = desc })
end

function M.toggleterm_keymap()
    nmap('<leader>T', '<cmd>ToggleTerm<CR>', "Open Toggleterm terminal")
end

function M.window_picker_keymap()
    nmap(
        "<leader>fw",
        function()
            local window_number = require('window-picker').pick_window()
            if window_number then vim.api.nvim_set_current_win(window_number) end
        end,
        "[F]ind[W]indow"
    )
end

return M
