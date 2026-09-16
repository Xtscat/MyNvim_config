-- modules/treesitter/spec.lua
--
-- Parser installation + highlighting. Kept isolated because it is the one
-- module that needs git + a C compiler at install time (air-gapped servers
-- should ship pre-built parsers and disable `ensure_installed`).

return {
    {
        "romus204/tree-sitter-manager.nvim",
        config = function() require("modules.treesitter.config").setup() end,
    },
}
