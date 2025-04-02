local option = vim.opt
local buffer = vim.b
local global = vim.g

-- Globol Settings --
global.mapleader = " "
-- global.python3_host_prog = "/home/xtscat/miniconda3/envs/Brain/bin/python3"
global.python3_host_prog = "/home/fmi/miniconda3/envs/xt/bin/python"
option.background = 'light'
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
-- terminal 模式使用 esc 退出
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
-- Buffer Settings
buffer.fileenconding = "utf-8"

vim.keymap.set("n", "ah", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "aj", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "ak", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "al", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "H", "^", { noremap = true, silent = true })
vim.keymap.set("v", "H", "^", { noremap = true, silent = true })
vim.keymap.set("n", "L", "$", { noremap = true, silent = true })
vim.keymap.set("v", "L", "$", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>l", "<cmd>echo expand('%:p')<cr>")

function no_paste(reg)
    return function(lines)
        --[ 返回 “” 寄存器的内容，用来作为 p 操作符的粘贴物 ]
        local content = vim.fn.getreg('"')
        return vim.split(content, '\n')
    end
end

vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = no_paste("+"), -- Pasting disabled
        ["*"] = no_paste("*"), -- Pasting disabled
    }
}
