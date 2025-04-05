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

