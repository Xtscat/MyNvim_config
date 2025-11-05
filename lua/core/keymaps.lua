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

-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         vim.cmd("Neotree show")
--         vim.cmd("Outline")
--     end
-- })
