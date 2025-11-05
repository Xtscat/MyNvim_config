-- ai/plugins.lua

return {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
    { "echasnovski/mini.diff" },
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        config = function()
            require("ai.config").codecompanion_config()
            require("ai.keymaps").codecompanion_keymaps()
        end
    }
}
