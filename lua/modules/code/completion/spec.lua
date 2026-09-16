-- modules/code/completion/spec.lua
--
-- Snippets and completion.

return {
    { "rafamadriz/friendly-snippets" },
    {
        "saghen/blink.cmp",
        version = "1.*",
        config = function() require("modules.code.completion.config").blink() end,
    },
}
