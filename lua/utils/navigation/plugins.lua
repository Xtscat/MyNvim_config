-- utils/navigation/plugins.lua
return {
    -- for telescope
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-lua/plenary.nvim' },
    {
        'nvim-telescope/telescope.nvim',
        cmd = "Telescope",
        event = "VeryLazy",
        config = function()
            require("utils.navigation.config").telescope_config()
            require("utils.navigation.keymaps").telescope_keymaps()
        end
    },

    -- for neo-tree
    { "MunifTanjim/nui.nvim" },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        config = function()
            require("utils.navigation.config").neotree_config()
            require("utils.navigation.keymaps").neotree_keymaps()
        end
    },

    -- for outline
    {
        "hedyhli/outline.nvim",
        config = function()
            require("utils.navigation.config").outline_config()
            require("utils.navigation.keymaps").outline_keymaps()
        end
    },
}
