return {
    cmd = "Telescope",
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    event = "VeryLazy",
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    keys = {
        { "<leader>ff",      ":Telescope find_files<cr>",                   desc = "find files" },
        { "<leader>fc",      ":Telescope live_grep<cr>",                    desc = "find codes" },
        { "<leader><space>", ":Telescope buffers<cr>",                      desc = "find buffers" },
    },
    config = function()
        -- You dont need to set any of these options. These are the default ones. Only
        -- the loading is important
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
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            }
        }
        -- To get fzf loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        require('telescope').load_extension('fzf')
    end
}
