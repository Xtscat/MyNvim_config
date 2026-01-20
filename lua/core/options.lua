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
buffer.fileencoding = "utf-8"


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
--  通过 OSC52 实现跨终端剪切板, OSC52 只负责读
-- ===================================================================
local function osc52_paste_disabled()
    return function()
        return { "" }, "v"
    end
end

vim.g.clipboard = {
    name = "OSC 52 (copy only)",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = osc52_paste_disabled(),
        ["*"] = osc52_paste_disabled(),
    },
}


-- 确保这一行仍然存在且有效
vim.opt.clipboard = 'unnamedplus'
