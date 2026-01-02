-- ai/plugins.lua

return {
    -- {
    --     "folke/snacks.nvim",
    --     opts = { input = {}, picker = {}, terminal = {} }
    -- },
    {
        "NickvanDyke/opencode.nvim",
        -- require utils/window/'snacks.nvim'
        config = function()
            require("ai.config").opencode_config()
            require("ai.keymaps").opencode_keymaps()
        end
    },
}
