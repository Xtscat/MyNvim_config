-- core/options.lua

local opt = vim.opt
local g = vim.g

-- Leader: <leader> key used in mappings
g.mapleader = " "

-- Editing basics
opt.virtualedit = "onemore"                                 -- allow cursor one char past EOL (useful for editing)
opt.backspace = { "indent", "eol", "start" }                -- make backspace behave like modern editors

-- Indent/tab
opt.tabstop = 4                                             -- display width of a <Tab>
opt.shiftwidth = 4                                          -- indent width for >> << and autoindent
opt.expandtab = true                                        -- insert spaces instead of <Tab>
opt.shiftround = true                                       -- round indent to multiple of shiftwidth
opt.autoindent = true                                       -- copy indent from current line when starting a new one
opt.smartindent = true                                      -- extra autoindent heuristics (best for code-like files)

-- UI
opt.number = true                                           -- show absolute line numbers
opt.relativenumber = true                                   -- show relative line numbers (for easier motions)
opt.showmode = false                                        -- don't show -- INSERT -- (often handled by statusline)
opt.cursorline = false                                      -- highlight the current line
opt.termguicolors = true                                    -- enable 24-bit RGB color
opt.signcolumn = "yes"                                      -- always show sign column (avoid text shifting)
opt.scrolloff = 4                                           -- keep N lines visible above/below cursor
opt.mouse = "a"                                             -- enable mouse support
opt.title = true                                            -- allow terminal title updates
opt.laststatus = 3                                          -- global statusline (single statusline for all windows)

-- Search
opt.hlsearch = true                                         -- highlight search matches
opt.ignorecase = true                                       -- case-insensitive search by default
opt.smartcase = true                                        -- unless the pattern contains uppercase
opt.incsearch = true                                        -- show matches while typing /pattern

-- Completion menu behavior
opt.completeopt = { "menuone", "noselect" }                 -- show menu even for one item; don't preselect

-- Command-line completion
opt.wildmenu = true                                         -- enhanced cmdline completion menu
opt.wildmode = { "longest:full", "full" }                   -- tab-complete to common prefix, then cycle

-- Splits (your preference: open new split left/top)
opt.splitright = false                                      -- :vsplit opens on the left when false
opt.splitbelow = false                                      -- :split opens above when false

-- File handling
opt.autoread = true                                         -- auto-reload file if changed outside nvim (when possible)
opt.fileencoding = "utf-8"                                  -- file encoding used when writing
opt.updatetime = 200                                        -- affects CursorHold and swap/refresh timings

-- Substitute preview
opt.inccommand = "split"                                    -- live preview of :substitute in a split window

-- Jumps
opt.jumpoptions = "stack"                                   -- make jumplist behave more like a stack (more predictable)

-- Comments / formatting
opt.formatoptions:remove({ "c", "r", "o" })                 -- don't auto-insert comment leaders on new lines

-- Swap/backup/undo
opt.swapfile = false                                        -- disable swapfile creation
opt.backup = false                                          -- disable backup file creation
opt.undofile = true                                         -- persistent undo across sessions
opt.undodir = vim.fn.expand("$HOME/.local/share/nvim/undo") -- where undo files are stored

-- Local project config (be careful; secure reduces risk)
opt.exrc = true                                             -- allow per-directory .nvimrc/.exrc
opt.secure = true                                           -- restrict unsafe commands in local rc files


-- ===================================================================
--  配置 SSH 和主机共享剪切板
-- ===================================================================
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
        ['+'] = 'win32yank.exe -o --lf',
        ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
}

-- 确保这一行仍然存在且有效
vim.opt.clipboard = 'unnamedplus'
