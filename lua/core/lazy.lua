-- core/lazy.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "ai.plugins" },
        { import = "dap.plugins" },
        { import = "lsp.plugins" },
        { import = "ui.plugins" },
        { import = "utils.editing.plugins" },
        { import = "utils.markdown.plugins" },
        { import = "utils.navigation.plugins" },
        { import = "utils.window.plugins" },
    },
    defaults = { lazy = false },
    checker = { enabled = false },
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.cmd("Neotree show")
            vim.cmd("Outline")
        end
    })
})
