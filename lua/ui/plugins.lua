-- ui/plugins.lua

return {
    -- for themes and fonts
    { 'nvim-tree/nvim-web-devicons', opt = true },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "VeryLazy",
        config = function()
            require("ui.config").treesitter_config()
        end
    },
    {
        'navarasu/onedark.nvim',
        lazy = false,
    },
    {
        'sainnhe/edge',
        lazy = false,
    },
    {
        'JManch/sunset.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require("ui.config").sunset_config()
        end,
    },

    -- for widgets
    {
        "dstein64/nvim-scrollview",
        config = function()
            require("ui.config").nvim_scrollview_config()
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = 'ibl',
        config = function()
            require("ui.config").indent_blankline_config()
        end
    },
    {
        "yamatsum/nvim-cursorline",
        config = function()
            require("ui.config").nvim_cursorline_config()
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("ui.config").lualine_config()
        end
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true
    },
    {
        "romgrk/barbar.nvim",
        config = function()
            require("ui.config").barbar_config()
            require("ui.keymaps").barbar_keymaps()
        end
    },
    {
        -- mamage nvim window
        -- left top: neo-tree
        -- left bottom: outline
        -- bottom: toggleterm
        -- right: codecompanionchat
        "folke/edgy.nvim",
        init = function()
            vim.opt.splitkeep = "screen"
        end,
        config = function()
            require("ui.config").edgy_config()
        end
    }
}
