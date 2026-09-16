-- modules/ft/markdown/keys.lua
--
-- Markdown buffer tweaks (paired with smark):
--   * disable blink completion in markdown buffers
--   * <Tab> / <S-Tab> indent / un-indent list items instead of inserting a tab

local Map = require("utils.map").with_prefix("Markdown")
local M = {}

function M.register()
    -- A dedicated augroup so re-sourcing does not stack autocmds.
    local group = vim.api.nvim_create_augroup("MarkdownSmarkOverrides", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "markdown",
        callback = function()
            -- blink reads this flag to decide whether to show its popup
            vim.b.completion = false
            -- buffer-local insert-mode maps. The table form is the
            -- vim.keymap.set style that utils/map.lua accepts.
            Map.imap("<Tab>", "<C-t>", { buffer = true, remap = true, desc = "Indent List" })
            Map.imap("<S-Tab>", "<C-d>", { buffer = true, remap = true, desc = "Un-indent List" })
        end,
    })
end

return M
