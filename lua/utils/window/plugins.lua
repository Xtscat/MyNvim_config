-- utils/window/plugins.lua

return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true,
        require("utils.window.keymaps").toggleterm_keymap()
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("utils.window.config").snacks_config()
            -- require("utils.window.keymaps").snacks_keymap()
        end
    },
    {
        "MarcusGrass/nvim_winpick",
        branch = "x86_64-unknown-linux-gnu-latest",
        lazy = false,
        config = function()
            require("utils.window.config").winpick_config()
            require("utils.window.keymaps").winpick_keymap()
        end
    },
}
