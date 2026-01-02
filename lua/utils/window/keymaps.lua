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

function M.winpick_keymap()
    nmap(
        "<leader>fw",
        function()
            require("nvim_winpick").pick_focus_window()
        end,
        "[F]ind[Window]"
    )
end

-- function M.snscks_keymap()
--
-- end

return M
