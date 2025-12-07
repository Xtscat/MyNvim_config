-- utils/navigation/config.lua

local M = {}

function M.telescope_config()
    require('telescope').setup {
        defaults = {
            layout_config = {
                width = 0.75,
                height = 0.75,
                -- padding = 0,
            }
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            }
        }
    }
    require('telescope').load_extension('fzf')
end

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
    require("outline").setup({
        -- symbols = {
        --     filter = {
        --         'Namespace', 'Class', 'Struct', 'Enum', 'Interface', 'Function', 'Method', 'Constructor', 'TypeAlias',
        --         'Macro'
        --     }
        -- }
    })
end

return M
