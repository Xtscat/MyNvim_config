-- modules/ft/markdown/config.lua

local M = {}

-- Preview layer for markdown. This replaced markview because of tables:
-- with 'wrap' on (Neovim's default and set nowhere in core/options.lua)
-- markview only *partially* renders pipe tables -- rows keep their raw '|',
-- the separator line is dropped, and wide tables are skipped entirely.
-- render-markdown rewrites tables as virtual lines and wraps individual
-- cells, so 'wrap' can stay on. Editing lists stays in smark (below).
function M.render_markdown()
    require("render-markdown").setup({
        -- Rounded corners, matching the look markview had.
        pipe_table = { preset = "round" },
    })
end

function M.smark()
    require("smark").setup()
end

return M
