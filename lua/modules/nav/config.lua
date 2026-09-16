-- modules/nav/config.lua
--
-- Setup for the navigation plugins: neo-tree (file tree), outline (symbols)
-- and hlslens (search highlight + match counter).

local M = {}

function M.neotree()
    -- neo-tree is the only file tree, so disable netrw entirely. Directory
    -- arguments (e.g. `nvim .`) are handled by the VimEnter autocmd in
    -- core/autocmds.lua, which runs `Neotree show`.
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("neo-tree").setup({
        close_if_last_window = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf", "edgy" },
        window = {
            position = "left",
            width = 30,
            mapping_options = {
                noremap = false,
                nowait = false,
            },
            -- Neo-tree's own keymap names (strings, not Lua functions).
            -- In the old config this table was returned and silently discarded;
            -- it must live inside setup() to take effect.
            mappings = {
                ["<cr>"] = "open",
                ["<esc>"] = "cancel",
                ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                ["l"] = "open",
                ["s"] = "open_rightbelow_vs",
                ["S"] = "open_split",
                ["w"] = "open_with_window_picker",
                ["C"] = "close_node",
                ["z"] = "close_all_nodes",
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy",
                ["m"] = "move",
                ["q"] = "close_window",
                ["R"] = "refresh",
                ["?"] = "show_help",
                ["<"] = "prev_source",
                [">"] = "next_source",
                ["i"] = "show_file_details",
            },
        },
        filesystem = {
            -- show dotfiles and gitignored files too
            filtered_items = {
                hide_hidden = false,
                hide_dotfiles = false,
                hide_gitignored = false,
            },
            -- follow the file you are editing in the tree
            follow_current_file = {
                enabled = true,
                leave_dirs_open = true,
            },
        },
    })
end

function M.outline()
    require("outline").setup({})
end

-- hlslens: show "n/m" match info when using n/N, and feed the current match
-- position to the scrollbar so hits show up as marks.
function M.hlslens()
    require("hlslens").setup({
        build_position_cb = function(plist)
            require("scrollbar.handlers.search").handler.show(plist.start_pos)
        end,
    })
    require("scrollbar.handlers.search").setup()
end

return M
