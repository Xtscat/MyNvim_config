-- modules/ui/spec.lua
--
-- Look and layout: colorscheme, statusline, winbar, tabline, scrollbar,
-- indent guides, cursorword highlight, window management (edgy) and
-- terminal (toggleterm).

local C = "modules.ui.config"
local function cfg(fn)
    return function() require(C)[fn]() end
end

return {
    -- colorscheme (day/night switch)
    { "JManch/sunset.nvim", lazy = false, priority = 1000, config = cfg("sunset") },
    -- day: sonph/onehalf's One Half Light -- the original VSCode palette.
    -- night: navarasu onedark. (2026-09-22: tried and rejected onedark's own
    -- light variant, sainnhe/edge, and the ClearAspect/onehalf Lua port.)
    {
        "sonph/onehalf",
        lazy = false,
        -- The repo keeps the Vim colorschemes (plus iTerm/Sublime variants) under
        -- vim/, so that subtree has to be on 'runtimepath' for
        -- `:colorscheme onehalflight` to resolve.
        config = function()
            local root = require("lazy.core.config").options.root
            vim.opt.runtimepath:append(root .. "/onehalf/vim")
        end,
    },
    { "navarasu/onedark.nvim", lazy = false },

    -- widgets
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "folke/which-key.nvim", opts = {} },
    { "nvim-lualine/lualine.nvim", config = cfg("lualine") },
    { "Bekaboo/dropbar.nvim", config = cfg("dropbar") },
    { "romgrk/barbar.nvim", config = cfg("barbar") },
    { "petertriho/nvim-scrollbar", config = cfg("scrollbar") },
    { "lukas-reineke/indent-blankline.nvim", config = cfg("indent_blankline") },
    { "yamatsum/nvim-cursorline", config = cfg("cursorline") },

    -- window / terminal
    {
        "folke/edgy.nvim",
        init = function() vim.opt.splitkeep = "screen" end,
        config = cfg("edgy"),
    },
    { "akinsho/toggleterm.nvim", version = "*", config = cfg("toggleterm") },
}
