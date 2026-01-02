local M = {}

function M.treesitter_config()
    require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "cpp", "python", "bash", "html", "lua", "markdown", "markdown_inline" },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        },
    }
end

return M
