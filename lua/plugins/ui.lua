return {
    {
        'navarasu/onedark.nvim',
        config = function()
            -- Lua
            require('onedark').setup {
                -- Main options --
                -- style = 'dark',   -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
                transparent = false,          -- Show/hide background
                term_colors = true,           -- Change terminal color as per the selected theme style
                ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
                cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

                -- toggle theme style ---
                toggle_style_key = nil,                                                              -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
                toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

                -- Change code style ---
                -- Options are italic, bold, underline, none
                -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
                code_style = {
                    comments = 'italic',
                    keywords = 'none',
                    functions = 'none',
                    strings = 'none',
                    variables = 'none'
                },

                -- Lualine options --
                lualine = {
                    transparent = false, -- lualine center bar transparency
                },

                -- Custom Highlights --
                colors = {},     -- Override default colors
                highlights = {}, -- Override highlight groups

                -- Plugins Config --
                diagnostics = {
                    darker = true,     -- darker colors for diagnostic
                    undercurl = true,  -- use undercurl instead of underline for diagnostics
                    background = true, -- use background color for virtual text
                },
            }
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        -- priority = 1000,
        config = function()
            require("catppuccin").setup({
                -- flavour = "auto", -- latte, frappe, macchiato, mocha
                -- background = { -- :h background
                --     light = "latte",
                --     dark = "mocha",
                -- },
                transparent_background = false, -- disables setting the background color.
                show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
                term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
                dim_inactive = {
                    enabled = false,            -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15,          -- percentage of the shade to apply to the inactive window
                },
                no_italic = false,              -- Force no italic
                no_bold = false,                -- Force no bold
                no_underline = false,           -- Force no underline
                styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = { "italic" },    -- Change the style of comments
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                    -- miscs = {}, -- Uncomment to turn off hard-coded styles
                },
                default_integrations = true,
                integrations = {
                    blink_cmp = true,
                    cmp = true,
                    barbar = true,
                    aerial = true,
                    gitsigns = true,
                    treesitter = true,
                    notify = false,
                    mason = true,
                    lspsaga = false,
                    neotree = true,
                    lsp_trouble = true,
                    which_key = true,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                    indent_blankline = {
                        enabled = true,
                        scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
                        colored_indent_levels = false,
                    },
                    barbecue = {
                        dim_dirname = true, -- directory name is dimmed by default
                        bold_basename = true,
                        dim_context = false,
                        alt_background = false,
                    },
                    telescope = {
                        enable = true,
                        style = "lavender"
                    },
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "bold" },
                            hints = { "bold" },
                            warnings = { "bold" },
                            information = { "bold" },
                        },
                        inlay_hints = {
                            background = true,
                        },
                    },
                },
            })

            -- setup must be called before loading
            -- vim.cmd.colorscheme "catppuccin"
        end,
    },
    {
        'JManch/sunset.nvim',
        dependencies = {
            "catppuccin/nvim",
            'navarasu/onedark.nvim',
        },
        lazy = false,
        priority = 1000,
        config = function()
            local catppuccin = require('catppuccin')
            local onedark = require('onedark')
            require('sunset').setup({
                latitude = 36.31,
                longitude = 104.48,
                day_callback = function()
                    if vim.g.is_day then
                        catppuccin.flavour = 'latte'
                        onedark.style = 'light'
                    else
                        catppuccin.flavour = 'mocha'
                        onedark.style = 'warmer'
                    end
                end,
            })
            if vim.g.is_day then
                vim.cmd.colorscheme "catppuccin"
                -- vim.cmd.colorscheme "onedark"
            else
                -- vim.cmd.colorscheme "catppuccin"
                vim.cmd.colorscheme "onedark"
            end
        end,
    },
    {
        -- 滚动条
        "dstein64/nvim-scrollview",
        config = function()
            require('scrollview').setup({
                excluded_filetypes = { 'neotree' },
                current_only = true,
                -- base = 'buffer',
                -- column = 80,
                signs_on_startup = { 'all' },
                scrollview_base = 'right',
                scrollview_signs_overflow = 'right',
                scrollview_folds_symbol = { 'right' },
                scrollview_textwidth_symbol = { 'right' },
                diagnostics_severities = { vim.diagnostic.severity.ERROR }
            })
        end
    },
    {
        -- 缩进线
        "lukas-reineke/indent-blankline.nvim",
        main = 'ibl',
        opts = {},
        config = function()
            require("ibl").setup({
                indent = {
                    char = { '╎' },
                    smart_indent_cap = true,
                },
                scope = {
                    show_start = false,
                    show_end = false,
                    highlight = { "Function", "Label" }
                }
            })
        end
    },
    {
        -- 显示相同单词
        "yamatsum/nvim-cursorline",
        config = function()
            require('nvim-cursorline').setup {
                cursorline = {
                    enable = false,
                    timeout = 50,
                    number = true,
                },
                cursorword = {
                    enable = true,
                    min_length = 3,
                    hl = {
                        -- fg="#CACACA",
                        -- standout = true,
                        -- underline = true,
                        -- reverse = true,
                        underline = true
                    },
                }
            }
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'catppuccin',
                    globalstatus = true,
                    always_show_tabline = true,
                },
                sections = {
                    lualine_c = {
                        function()
                            return require('lsp-progress').progress()
                        end
                    }
                }
            })
            vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
            vim.api.nvim_create_autocmd("User", {
                group = "lualine_augroup",
                pattern = "LspProgressStatusUpdated",
                callback = require("lualine").refresh,
            })
        end,
    },
    {
        "hedyhli/outline.nvim",
        config = function()
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    vim.cmd("Outline!")
                end
            })
            vim.keymap.set("n", "<leader>a", "<cmd>Outline<CR>",
                { desc = "Toggle Outline" })

            require("outline").setup {
                outline_window = {
                    show_relative_numbers = true,
                    width = 17,
                },
                outline_items = {
                    show_symbol_details = false,
                    auto_expand = true
                },
                symbols = {
                    filter = {
                        default = { "Variable", "Package", "String", exclude = true },
                        -- python = {"function", "Class"},
                    }
                },
                symbol_folding = {
                    -- Depth past which nodes will be folded by default. Set to false to unfold all on open.
                    autofold_depth = 3,
                    -- When to auto unfold nodes
                    auto_unfold = {
                        -- Auto unfold currently hovered symbol
                        hovered = true,
                        -- Auto fold when the root level only has this many nodes.
                        -- Set true for 1 node, false for 0.
                        only = true,
                    },
                    markers = { '', '' },
                },
            }
        end,
    },
    {
        -- tt 打开侧边目录
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        -- event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            {
                's1n7ax/nvim-window-picker',
                version = '2.*',
                config = function()
                    require 'window-picker'.setup({
                        filter_rules = {
                            include_current_win = false,
                            autoselect_one = true,
                            -- filter using buffer options
                            bo = {
                                -- if the file type is one of following, the window will be ignored
                                filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                                -- if the buffer type is one of following, the window will be ignored
                                buftype = { 'terminal', "quickfix" },
                            },
                        },
                    })
                end,
            },
        },
        vim.api.nvim_command('autocmd VimEnter * Neotree show'),
        vim.keymap.set({ "n", "v" }, "tt", [[<cmd>Neotree toggle<CR>]]),
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                window = {
                    position = "left",
                    width = 30,
                    mapping_options = {
                        noremap = false,
                        nowait = false,
                    },
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
                },
            })
        end
    },
    {
        -- indent line
        'vidocqh/auto-indent.nvim',
        config = function()
            require("auto-indent").setup({
                lightmode = true,     -- Lightmode assumes tabstop and indentexpr not change within buffer's lifetime
                indentexpr = nil,     -- Use vim.bo.indentexpr by default, see 'Custom Indent Evaluate Method'
                ignore_filetype = {}, -- Disable plugin for specific filetypes, e.g. ignore_filetype = { 'javascript' }
            })
        end
    },
    {
        -- 顶端 buffer 配置
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-tree/nvim-web-devicons'
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        config = function()
            require("barbar").setup({
                icons = {
                    buffer_index = true,
                    buffer_numbers = true,
                },
                -- sidebar_filetypes = {
                --     ['neo-tree'] = { event = 'BufWipeout' },
                --     Outline = { event = 'BufWinLeave', text = 'symbols-outline', align = 'right' }
                -- }
            })
        end,
        opts = {
            vim.keymap.set("n", "<leader>bp", [[<Cmd>BufferPickDelete<CR>]], { noremap = true, silent = true },
                { desc = "[P]ick[B]uffertoclose" }),
            vim.keymap.set("n", "<leader>cb", [[<Cmd>BufferClose<CR>]], { noremap = true, silent = true },
                { desc = "[C]lose[B]uffer" }),
            vim.keymap.set("n", "<leader>c[", [[<Cmd>BufferCloseBuffersLeft<CR>]], { noremap = true, silent = true },
                { desc = "Close Left Buffer" }),
            vim.keymap.set("n", "<leader>c]", [[<Cmd>BufferCloseBuffersRight<CR>]], { noremap = true, silent = true },
                { desc = "Close Right Buffer" }),
            vim.keymap.set("n", "\\[", [[<Cmd>BufferPrevious<CR>]], { noremap = true, silent = true },
                { desc = "Previous Buffer" }),
            vim.keymap.set("n", "\\]", [[<Cmd>BufferNext<CR>]], { noremap = true, silent = true },
                { desc = "Next Buffer" }),
            vim.keymap.set("n", "\\{", [[<Cmd>BufferMovePrevious<CR>]], { noremap = true, silent = true },
                { desc = "Move Buffer to Previous" }),
            vim.keymap.set("n", "\\}", [[<Cmd>BufferMoveNext<CR>]], { noremap = true, silent = true },
                { desc = "Move Buffer to Next" }),
            vim.keymap.set("n", "<leader>1", [[<Cmd>BufferGoto 1<CR>]], { noremap = true, silent = true },
                { desc = "Buffer 1" }),
            vim.keymap.set("n", "<leader>2", [[<Cmd>BufferGoto 2<CR>]], { noremap = true, silent = true },
                { desc = "Buffer 2" }),
            vim.keymap.set("n", "<leader>3", [[<Cmd>BufferGoto 3<CR>]], { noremap = true, silent = true },
                { desc = "Buffer 3" }),
            vim.keymap.set("n", "<leader>4", [[<Cmd>BufferGoto 4<CR>]], { noremap = true, silent = true },
                { desc = "Buffer 4" }),
            vim.keymap.set("n", "<leader>5", [[<Cmd>BufferGoto 5<CR>]], { noremap = true, silent = true },
                { desc = "Buffer 5" }),
            vim.keymap.set("n", "<leader>6", [[<Cmd>BufferGoto 6<CR>]], { noremap = true, silent = true },
                { desc = "Buffer 6" }),
            vim.keymap.set("n", "<leader>7", [[<Cmd>BufferGoto 7<CR>]], { noremap = true, silent = true },
                { desc = "Buffer 7" }),
            vim.keymap.set("n", "<leader>8", [[<Cmd>BufferGoto 8<CR>]], { noremap = true, silent = true },
                { desc = "Buffer 8" }),
            vim.keymap.set("n", "<leader>9", [[<Cmd>BufferGoto 9<CR>]], { noremap = true, silent = true },
                { desc = "Buffer 9" }),
            vim.keymap.set("n", "<leader>0", [[<Cmd>BufferLast<CR>]], { noremap = true, silent = true },
                { desc = "Buffer Last" }),
        },
    },
}
