-- modules/code/format/spec.lua
--
-- Formatter (conform.nvim). Loaded lazily on VeryLazy; the <c-l> keymap calls
-- conform directly so it works even before the plugin has finished loading.

return {
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        config = function() require("modules.code.format.config").conform() end,
    },
}
