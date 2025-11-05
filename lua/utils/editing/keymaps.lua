-- utils/editing/keymaps.lua

local M = {}

local nmap = function(keys, func, desc)
    if desc then
        desc = 'Editing: ' .. desc
    end
    vim.keymap.set('n', keys, func, { desc = desc })
end

function M.hlslens_keymaps()
    nmap('n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
    nmap('N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])
    nmap('<Esc>', '<Cmd>noh<CR>')
end

function M.nvim_surround_keymaps()
    require("nvim-surround").setup({
        keymaps = {
            -- 添加包围 (Normal Mode): <Leader>sa
            -- "sa" 可记为 "Surround Add"
            -- 使用方法: <Leader>sa + 文本对象 + 包围符号
            -- 示例 1: <Leader>saiw)  ->  给光标下的单词(word)加上圆括号 -> (word)
            -- 示例 2: <Leader>sat"   ->  给整个HTML标签(tag)加上双引号 -> "<b>text</b>"
            normal = "<Leader>sa",

            -- 删除包围 (Normal Mode): <Leader>sd
            -- "sd" 可记为 "Surround Delete"
            -- 使用方法: <Leader>sd + 要删除的包围符号
            -- 示例: <Leader>sd"  ->  删除光标内外围的双引号
            delete = "<Leader>sd",

            -- 更改/替换包围 (Normal Mode): <Leader>sr
            -- "sr" 可记为 "Surround Replace"
            -- 使用方法: <Leader>sr + 旧符号 + 新符号
            -- 示例: <Leader>sr'"  ->  将外围的单引号(')替换为双引号(")
            change = "<Leader>sr",

            -- 添加包围 (Visual Mode): <Leader>s
            -- 使用方法: 先用 v 或 V 选中一段文本, 然后按 <Leader>s, 最后输入你想要的包围符号
            visual = "<Leader>s",
        },
    })
end

return M
