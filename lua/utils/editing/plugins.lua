-- utils/editing/plugings.lua
return {
   {
        'nguyenvukhang/nvim-toggler',
        config = function()
            require("utils.editing.config").nvim_toggler_config()
        end

    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require("utils.editing.config").comment_config()
        end
    },
    {
        "kevinhwang91/nvim-hlslens",
        config = function()
            require("utils.editing.config").hlslens_config()
            require("utils.editing.keymaps").hlslens_keymaps()
        end
    },
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("utils.editing.config").autosave_config()
        end
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("utils.editing.keymaps").nvim_surround_keymaps()
        end

    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    {
        'echasnovski/mini.ai',
        event = "VeryLazy",
        config = true,
    },
    {
        "kawre/neotab.nvim",
        config = function()
            require("utils.editing.config").neotab_config()
        end
    },
    {
        "ethanholz/nvim-lastplace",
        config = true
    },
    {
        "folke/which-key.nvim",
        config = true,
    }
}
