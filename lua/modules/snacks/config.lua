-- modules/snacks/config.lua
--
-- snacks.nvim is the picker / input engine. Only the pieces we actually use
-- are enabled here; the keymaps live with the features that use them
-- (modules/nav/keys.lua, modules/code/lsp/keys.lua, ...).

local M = {}

function M.setup()
    -- A few extra highlight groups snacks looks up by name.
    vim.api.nvim_set_hl(0, "SnacksIndentGray", { fg = "#31353F" })
    vim.api.nvim_set_hl(0, "SnacksPickerCursorline", { bg = "#2a2e38" })
    vim.api.nvim_set_hl(0, "SnacksPickerBorder", { link = "FloatBorder" })

    require("snacks").setup({
        -- input: replaces vim.ui.input (used by :Vsp/:Hsp, LSP rename, ...).
        -- border must be "none" explicitly: snacks' default is `true`, which
        -- resolves to vim.o.winborder and falls back to "rounded" — and a
        -- rounded border on the square float body looked wrong.
        input = { enabled = true, border = "none" },

        -- notifications: use Neovim's default instead of snacks'
        notify = { enabled = false },
        notifier = { enabled = false, style = { anchor = "bottom_right" } },

        -- the picker used by <leader>ff / <leader>fc / gd / gr / ...
        picker = {
            enabled = true,
            -- "ivy": a bar at the bottom, input on top, list + preview below
            layout = {
                preset = "ivy",
                width = 0.9,
                height = 0.85,
                preview = "right",
            },
        },
    })
end

return M
