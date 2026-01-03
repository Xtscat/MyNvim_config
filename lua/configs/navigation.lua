local M = {}
local Map = require("utils.map").with_prefix("Navigation")

function M.neotree_config()
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
        },
        filesystem = {
            filtered_items = {
                hide_hidden = false,
                hide_dotfiles = false,
                hide_gitignored = false
            },
            follow_current_file = {
                enable = true,
                leave_dits_open = true
            }
        }
    })
end

function M.outline_config()
    require("outline").setup({})
end

function M.neotree_keymaps()
    -- for neotree
    return {
        Map.nmap("tt", "<cmd>Neotree toggle<CR>", "Toggle Neotree Window"),
        window = {
            mappings = {
                ["<cr>"] = "open",
                ["<esc>"] = "cancel", -- close preview or floating neo-tree window
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
                ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
                ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
                ["q"] = "close_window",
                ["R"] = "refresh",
                ["?"] = "show_help",
                ["<"] = "prev_source",
                [">"] = "next_source",
                ["i"] = "show_file_details",
            }
        }
    }
end

function M.outline_keymaps()
    -- for outline
    Map.nmap("<leader>a", "<cmd>Outline<CR>", "Toggle Outline Window")
end

return M
