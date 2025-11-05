-- ui/keymaps.lua

local M = {}

local nmap = function(keys, func, desc)
    if desc then
        desc = 'UI: ' .. desc
    end
    vim.keymap.set('n', keys, func, { desc = desc })
end

function M.barbar_keymaps()
    nmap("<leader>pb", [[<Cmd>BufferPickDelete<CR>]], "[P]ick[B]uffertoclose")
    nmap("<leader>cb", [[<Cmd>BufferClose<CR>]], "[C]lose[B]uffer")
    nmap("<leader>c[", [[<Cmd>BufferCloseBuffersLeft<CR>]], "Close Left Buffer")
    nmap("<leader>c]", [[<Cmd>BufferCloseBuffersRight<CR>]], "Close Right Buffer")
    nmap("\\[", [[<Cmd>BufferPrevious<CR>]], "Previous Buffer")
    nmap("\\]", [[<Cmd>BufferNext<CR>]], "Next Buffer")
    nmap("\\{", [[<Cmd>BufferMovePrevious<CR>]], "Move Buffer to Previous")
    nmap("\\}", [[<Cmd>BufferMoveNext<CR>]], "Move Buffer to Next")
    nmap("<leader>1", [[<Cmd>BufferGoto 1<CR>]], "Buffer 1")
    nmap("<leader>2", [[<Cmd>BufferGoto 2<CR>]], "Buffer 2")
    nmap("<leader>3", [[<Cmd>BufferGoto 3<CR>]], "Buffer 3")
    nmap("<leader>4", [[<Cmd>BufferGoto 4<CR>]], "Buffer 4")
    nmap("<leader>5", [[<Cmd>BufferGoto 5<CR>]], "Buffer 5")
    nmap("<leader>6", [[<Cmd>BufferGoto 6<CR>]], "Buffer 6")
    nmap("<leader>7", [[<Cmd>BufferGoto 7<CR>]], "Buffer 7")
    nmap("<leader>8", [[<Cmd>BufferGoto 8<CR>]], "Buffer 8")
    nmap("<leader>9", [[<Cmd>BufferGoto 9<CR>]], "Buffer 9")
    nmap("<leader>0", [[<Cmd>BufferLast<CR>]], "Buffer Last")
end

return M
