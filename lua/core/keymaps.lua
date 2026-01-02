-- core/keymaps.lua

local Map = require("utils.map").with_prefix("Core")

Map.map("t", "<Esc>", [[<C-\><C-n>]], "Terminal: Exit Insert Mode")

Map.nmap("<leader>l", "<cmd>echo expand('%:p')<cr>", "System: Show Full Path")


Map.nmap("ah", "<C-w>h", "Window: Focus Left")
Map.nmap("aj", "<C-w>j", "Window: Focus Down")
Map.nmap("ak", "<C-w>k", "Window: Focus Up")
Map.nmap("al", "<C-w>l", "Window: Focus Right")

Map.map({ "n", "v" }, "H", "^", "Move: To Line Start")
Map.map({ "n", "v" }, "L", "$", "Move: To Line End")

-----------------------------------------------------------
-- 自定义 1/4 屏幕滚动 (Ctrl-j / Ctrl-k)
-----------------------------------------------------------
-- 内部函数：计算并执行滚动
local function move_quarter(direction)
    local win_height = vim.api.nvim_win_get_height(0)
    local step = math.max(1, math.floor(win_height / 4))
    -- 执行跳转
    vim.cmd("normal! m'") -- 记录当前位置到标记中
    vim.cmd("normal! " .. step .. direction)
end

Map.map({ "n", "x" }, "<C-j>", function() move_quarter("j") end, "Scroll: Down 1/4 Screen")
Map.map({ "n", "x" }, "<C-k>", function() move_quarter("k") end, "Scroll: Up 1/4 Screen")
