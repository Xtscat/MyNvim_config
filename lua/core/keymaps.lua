-- core/keymaps.lua

-- terminal 模式使用 esc 退出
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.keymap.set("n", "ah", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "aj", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "ak", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "al", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "H", "^", { noremap = true, silent = true })
vim.keymap.set("v", "H", "^", { noremap = true, silent = true })
vim.keymap.set("n", "L", "$", { noremap = true, silent = true })
vim.keymap.set("v", "L", "$", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>l", "<cmd>echo expand('%:p')<cr>")

-- 将ctrl-d/u修改为滚动1/4屏幕, 并映射到ctrl-j/k
local function move_quarter(direction)
    local win_height = vim.api.nvim_win_get_height(0)
    local step = math.max(1, math.floor(win_height / 4))
    vim.cmd("normal! m'")
    vim.cmd("normal!" .. step .. direction)
end

vim.keymap.set({ "n", "x" }, "<C-j>", function() move_quarter("j") end, { desc = "Down 1/4 screen" })
vim.keymap.set({ "n", "x" }, "<C-k>", function() move_quarter("k") end, { desc = "Up 1/4 screen" })

-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         vim.cmd("Neotree show")
--         vim.cmd("Outline")
--     end
-- })
