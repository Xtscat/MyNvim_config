-- modules/ft/markdown/spec.lua
--
-- Markdown-only plugins live under ft/. Buffer-local options for other
-- filetypes stay in after/ftplugin/ (no plugin needed there).

local C = "modules.ft.markdown.config"
local function cfg(fn)
    return function() require(C)[fn]() end
end

return {
    { "OXY2DEV/markview.nvim", lazy = false, config = cfg("markview") },
    { "yutanagano/smark.nvim", config = cfg("smark") },
}
