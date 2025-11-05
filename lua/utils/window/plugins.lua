-- utils/window/plugins.lua

return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true,
        require("utils.window.keymaps").toggleterm_keymap()
    },
    {
        "s1n7ax/nvim-window-picker",
        event = "VeryLazy",
        config = function()
            require("utils.window.config").window_picker_config()
            require("utils.window.keymaps").window_picker_keymap()
        end
    },
}
