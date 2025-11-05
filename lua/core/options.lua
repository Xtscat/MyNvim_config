-- core/options.lua

local option = vim.opt
local buffer = vim.b
local global = vim.g

-- Globol Settings --
global.mapleader = " "
option.clipboard = "unnamedplus"
option.virtualedit = "onemore"
option.showmode = false
option.backspace = { "indent", "eol", "start" }
option.scrolloff = 4
option.tabstop = 4
option.shiftwidth = 4
option.expandtab = true
option.shiftround = true
option.autoindent = true
option.smartindent = true
option.number = true
option.relativenumber = true
option.wildmenu = true
option.hlsearch = true
option.ignorecase = true
option.smartcase = true
option.completeopt = { "noselect", "menuone" }
option.cursorline = false
option.termguicolors = true
option.signcolumn = "yes"
option.autoread = true
option.title = true
option.swapfile = false
option.backup = false
option.updatetime = 50
option.mouse = "a"
option.undofile = true
option.undodir = vim.fn.expand('$HOME/.local/share/nvim/undo')
option.exrc = true
option.wrap = true
option.splitright = false
option.splitbelow = false
-- Buffer Settings
buffer.fileenconding = "utf-8"


-- function no_paste(reg)
--     return function(lines)
--         --[ 返回 “” 寄存器的内容，用来作为 p 操作符的粘贴物 ]
--         local content = vim.fn.getreg('"')
--         return vim.split(content, '\n')
--     end
-- end
--
-- vim.g.clipboard = {
--     name = "OSC 52",
--     copy = {
--         ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--         ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--     },
--     paste = {
--         ["+"] = no_paste("+"), -- Pasting disabled
--         ["*"] = no_paste("*"), -- Pasting disabled
--     }
-- }

-- ===================================================================
--  配置 WSL 与 Windows 共享剪切板
--  通过直接调用 win32yank.exe 实现双向同步
-- ===================================================================
vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
        ['+'] = 'win32yank.exe -i --crlf',
        ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
        ['+'] = 'win32yank.exe -o --crlf',
        ['*'] = 'win32yank.exe -o --crlf',
    },
    cache_enabled = 0,
}

-- 确保这一行仍然存在且有效
vim.opt.clipboard = 'unnamedplus'
