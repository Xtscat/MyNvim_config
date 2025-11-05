-- lsp/plugins.lua

return {
    -- for lsp
    {
        "williamboman/mason.nvim",
        config = function()
            require("lsp.config").mason_config()
        end
    },
    { "williamboman/mason-lspconfig.nvim" },
    {
        "nvimdev/lspsaga.nvim",
        config = function()
            require("lsp.config").lspsaga_config()
            require("lsp.keymaps").lsp_keymaps()
        end
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("lsp.config").lsp_config()
        end
    },
    {
        "j-hui/fidget.nvim",
        config = function()
            require("lsp.config").fidget_config()
        end
    },

    -- for cmp
    { "rafamadriz/friendly-snippets" },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        run = "make install_jsregexp",
    },
    {
        'saghen/blink.cmp',
        version = "1.*",
        config = function()
            require("lsp.keymaps").blink_keymaps()
            require("lsp.config").blink_config()
        end,
    },

    -- for conform
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        config = function()
            require("lsp.config").conform_config()
            require("lsp.keymaps").conform_keymaps()
        end
    },
}
