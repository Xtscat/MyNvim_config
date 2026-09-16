-- modules/snacks/spec.lua
--
-- snacks.nvim is the picker / input engine. It is eager (priority 1000)
-- because several modules call into it. It owns no keymaps; those are
-- registered by the feature modules that use them (nav, code/lsp, ...).

return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = function() require("modules.snacks.config").setup() end,
    },
}
