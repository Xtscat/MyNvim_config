-- modules/editor/spec.lua
--
-- Editing experience that is independent of LSP and of UI chrome.
-- (Search-highlighting keys live in modules/nav.)

local C = "modules.editor.config"
local function cfg(fn)
    return function() require(C)[fn]() end
end

return {
    { "numToStr/Comment.nvim", event = "VeryLazy", opts = require(C).comment },
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    { "echasnovski/mini.ai", event = "VeryLazy", opts = {} },
    { "kawre/neotab.nvim", config = cfg("neotab") },
    { "nguyenvukhang/nvim-toggler", config = cfg("toggler") },
    { "Pocco81/auto-save.nvim", config = cfg("autosave") },
    { "ethanholz/nvim-lastplace", opts = {} },
}
