local M = {}
-- local Map = require("utils.map").with_prefix("Navigation")

M.tex_config = function()
    vim.g.maplocalleader = " "
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_quickfix_mode = 1
    vim.g.tex_flavor = "latex"
end

return M
