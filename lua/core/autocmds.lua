-- core/autocmds.lua

-- Open the file tree and outline on startup.
-- (Behaviour carried over from the previous config; remove lines you dislike.)
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd("Neotree show")
        vim.cmd("Outline")
    end,
})
