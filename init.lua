-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- gemini api key
vim.env.GEMINI_API_KEY = "AIzaSyAmbGm9jIIvbS5nSHZaQUQGTu4g17MhBZo"
-- vim.env.GEMINI_API_KEY="AIzaSyAjQgkvDksXTgXWRloiS5Fxp_0Xwo0cmPQ"

-- deepseek huoshan api key
vim.env.Deepseek_API_KEY = "c86dce01-1fb2-401b-a659-18e21cfe2d34"

-- baseconfig
require("baseconfig")

-- 加载"lua/plugins"下的插件
require("lazy").setup("plugins")

-- vim.api.nvim_command('autocmd FileType lua,python,c,cpp AerialOpen!')
-- vim.api.nvim_command('autocmd VimEnter * Neotree show')

-- -- 设置左侧边栏布局函数
-- function _G.SetupLeftSidebar()
--     -- 首先打开Neotree
--     vim.cmd("Neotree show")
--
--     -- 获取当前窗口高度
--     local win_height = vim.api.nvim_win_get_height(0)
--
--     -- 调整Neotree窗口高度为屏幕的上半部分
--     vim.cmd("resize " .. math.floor(win_height / 2))
--
--     -- 打开Aerial在下半部分
--     vim.cmd("AerialOpen")
--
--     -- 回到编辑窗口（主窗口）
--     vim.cmd("wincmd l")
-- end
--
-- -- 在Vim启动时设置左侧布局
-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         -- 延迟一点执行以确保所有插件都已加载
--         vim.defer_fn(function()
--             SetupLeftSidebar()
--         end, 100)
--     end
-- })
--
-- -- 定义一个命令，方便手动触发
-- vim.api.nvim_create_user_command('SetupSidebar', function()
--     SetupLeftSidebar()
-- end, {})
