-- modules/treesitter/config.lua

local M = {}

function M.setup()
    require("tree-sitter-manager").setup({
        ensure_installed = { "c", "cpp", "python", "bash", "html", "lua", "markdown", "markdown_inline" },
        highlight = true,
    })
end

return M
