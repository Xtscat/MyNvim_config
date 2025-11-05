-- utils/navigation/keymaps.lua

local M = {}

local nmap = function(keys, func, desc)
    if desc then
        desc = 'Navigation: ' .. desc
    end
    vim.keymap.set('n', keys, func, { desc = desc })
end

function M.telescope_keymaps()
    -- for telescope
    nmap("<leader>ff", "<cmd>Telescope find_files<CR>", "Find Files")
    nmap("<leader>fc", "<cmd>Telescope live_grep<CR>", "Find Codes")
    nmap("<leader><space>", "<cmd>Telescope buffers<CR>", "Find Buffers")
end

function M.neotree_keymaps()
    -- for neotree
    return{
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

return M
