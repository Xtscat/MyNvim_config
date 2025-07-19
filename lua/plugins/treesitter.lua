return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = { "c", "cpp", "python", "bash", "markdown", "markdown_inline"},
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        }
    end
}
