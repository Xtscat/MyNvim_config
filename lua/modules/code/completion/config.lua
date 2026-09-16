-- modules/code/completion/config.lua
--
-- blink.cmp setup.
--
-- Snippets: blink's default snippet source reads `friendly-snippets` straight
-- from the runtimepath and expands them with Neovim's built-in `vim.snippet`.
-- That is why there is no LuaSnip anywhere and no `snippets.expand` override.

local M = {}

function M.blink()
    require("blink.cmp").setup({
        completion = {
            keyword = { range = "full" }, -- consider the whole word before the cursor
            trigger = {
                show_on_trigger_character = true, -- pop up after e.g. "." or ">"
                show_on_blocked_trigger_characters = { " ", "\n", "\t" },
            },
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
            -- don't preselect the first row; insert the highlighted item as you type
            list = { selection = { preselect = false, auto_insert = true } },
            menu = {
                draw = {
                    -- two columns: [kind icon] [label + description]
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                    },
                    -- highlight the label with treesitter for the current filetype
                    treesitter = { "lsp" },
                },
            },
        },

        -- Whether the popup is allowed in the current buffer.
        enabled = function()
            return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
        end,

        appearance = { nerd_font_variant = "mono" },

        -- Sources in priority order (bigger score_offset = ranked higher).
        sources = {
            default = { "buffer", "lsp", "path", "snippets" },
            providers = {
                lsp = { score_offset = 4 },
                snippets = { score_offset = 3 },
                path = { score_offset = 2 },
                buffer = { score_offset = 1 },
            },
        },

        -- Completion while typing on the ":" command line.
        cmdline = {
            completion = {
                menu = { auto_show = true },
                list = { selection = { preselect = false, auto_insert = true } },
            },
        },

        -- Use blink's Rust fuzzy matcher when the prebuilt lib is present;
        -- otherwise fall back to pure Lua with a warning.
        fuzzy = { implementation = "prefer_rust_with_warning" },

        -- Start from "none" and define only the keys we want.
        keymap = {
            preset = "none",
            ["<C-space>"] = { "hide" },
            ["<CR>"] = { "select_and_accept", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        },
    })
end

return M
