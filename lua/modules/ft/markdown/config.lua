-- modules/ft/markdown/config.lua

local M = {}

function M.markview()
    require("markview").setup({
        markdown = { enable = true },
        markdown_inline = { enable = true },
        latex = { enable = true },
        preview = { enable = true },
    })
end

function M.smark()
    require("smark").setup()
end

return M
