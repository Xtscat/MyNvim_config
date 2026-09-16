-- modules/nav/spec.lua
--
-- Browsing and jumping: file tree (neo-tree), symbol outline, search
-- highlighting (hlslens) and personal annotations (haunt). The picker
-- itself is provided by the snacks engine; its keymaps are registered in
-- this module's keys.lua.

local C = "modules.nav.config"
local function cfg(fn)
    return function() require(C)[fn]() end
end

return {
    { "MunifTanjim/nui.nvim" },
    { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", config = cfg("neotree") },
    { "hedyhli/outline.nvim", config = cfg("outline") },
    { "kevinhwang91/nvim-hlslens", config = cfg("hlslens") },
    {
        "TheNoeTrevino/haunt.nvim",
        opts = { per_branch_bookmarks = true },
    },
}
