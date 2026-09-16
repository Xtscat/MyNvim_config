-- modules/code/format/keys.lua

local Map = require("utils.map").with_prefix("Format")
local M = {}

function M.register()
    -- Calling conform directly (instead of <cmd>Format) means the keymap works
    -- even before the lazily-loaded plugin has finished loading.
    Map.nmap("<c-l>", function()
        require("conform").format({ async = true, lsp_fallback = true })
    end, "Format Buffer")
end

return M
