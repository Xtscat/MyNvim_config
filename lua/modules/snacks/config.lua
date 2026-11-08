-- modules/snacks/config.lua
--
-- snacks.nvim is the picker / input engine. Only the pieces we actually use
-- are enabled here; the keymaps live with the features that use them
-- (modules/nav/keys.lua, modules/code/lsp/keys.lua, ...).

local M = {}

function M.setup()
    require("snacks").setup({
        -- input: replaces vim.ui.input (used by :Vsp/:Hsp, LSP rename, ...).
        -- border must be "none" explicitly: snacks' default is `true`, which
        -- resolves to vim.o.winborder and falls back to "rounded" — and a
        -- rounded border on the square float body looked wrong.
        input = { enabled = true, border = "none" },

        -- notifications: use Neovim's default instead of snacks'
        notify = { enabled = false },
        notifier = { enabled = false, style = { anchor = "bottom_right" } },

        -- big files: anything above 20MB (or with an average line length over
        -- snacks' default 1000 chars) is given the filetype "bigfile", and
        -- snacks' own hook then switches off completion, MatchParen, folds,
        -- statuscolumn and conceallevel for that buffer. The plugins we run on
        -- top are kept off the filetype in their own configs, not in a hook
        -- here: gitsigns' on_attach (modules/git/config.lua), nvim-scrollbar's
        -- excluded_filetypes and nvim-cursorline's disable_filetypes
        -- (modules/ui/config.lua), auto-save's condition
        -- (modules/editor/config.lua) and the hlslens call in the n/N keymaps
        -- (modules/nav/keys.lua).
        bigfile = { enabled = true, size = 20 * 1024 * 1024 },

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
