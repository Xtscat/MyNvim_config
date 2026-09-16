-- modules/code/lsp/spec.lua
--
-- Language servers and their diagnostics UI (fidget, trouble).

local C = "modules.code.lsp.config"
local function cfg(fn)
    return function() require(C)[fn]() end
end

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        config = cfg("lsp"),
    },
    { "williamboman/mason.nvim", config = cfg("mason") },
    { "j-hui/fidget.nvim", config = cfg("fidget") },
    {
        "folke/trouble.nvim",
        lazy = false,
        cmd = "Trouble",
        config = cfg("trouble"),
    },
}
