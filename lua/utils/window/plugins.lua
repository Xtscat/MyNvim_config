-- utils/window/plugins.lua

return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true,
        require("utils.window.keymaps").toggleterm_keymap()
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
