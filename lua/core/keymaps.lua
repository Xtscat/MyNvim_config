-- core/keymaps.lua
--
-- Global keymaps that are NOT owned by a single plugin/module.
-- Plugin-scoped keymaps live in lua/modules/<module>/keys.lua.

local Map = require("utils.map").with_prefix("Core")

Map.map("t", "<Esc>", [[<C-\><C-n>]], "Exit Terminal Mode")

-- Copy the current buffer's absolute path to the system clipboard
Map.nmap("<leader>l", function()
    local path = vim.fn.expand("%:p")
    if path == "" then
        vim.notify("No file name for current buffer", vim.log.levels.WARN)
        return
    end
    require("utils.clipboard").yank(path)
    vim.notify(path .. "  (copied to clipboard)", vim.log.levels.INFO)
end, "Copy Full Path to Clipboard")

-- Window focus
Map.nmap("ah", "<C-w>h", "Focus Left")
Map.nmap("aj", "<C-w>j", "Focus Down")
Map.nmap("ak", "<C-w>k", "Focus Up")
Map.nmap("al", "<C-w>l", "Focus Right")

-- Line start/end
Map.map({ "n", "v" }, "H", "^", "To Line Start")
Map.map({ "n", "v" }, "L", "$", "To Line End")

-- Scroll 1/4 screen (Ctrl-j / Ctrl-k)
local function move_quarter(direction)
    local win_height = vim.api.nvim_win_get_height(0)
    local step = math.max(1, math.floor(win_height / 4))
    vim.cmd("normal! m'") -- record position in the jumplist
    vim.cmd("normal! " .. step .. direction)
end

Map.map({ "n", "x" }, "<C-j>", function() move_quarter("j") end, "Scroll Down 1/4 Screen")
Map.map({ "n", "x" }, "<C-k>", function() move_quarter("k") end, "Scroll Up 1/4 Screen")
