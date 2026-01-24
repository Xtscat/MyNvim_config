-- configs/tex.lua

local M = {}

M.tex_config = function()
    -- VimTeX globals (read during plugin startup)
    vim.g.maplocalleader = " "
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_quickfix_mode = 1
    vim.g.tex_flavor = "latex"

    -- LaTeX buffers: soft wrap long lines inside the window
    local augroup = vim.api.nvim_create_augroup("UserTexSettings", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = { "tex", "plaintex", "bib" },
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            vim.opt_local.breakindent = true
            -- vim.opt_local.showbreak = ">> "
            vim.opt_local.smartindent = false
        end,
    })
end

return M
