return {
    {
        -- vim 中使用 ranger
        'kevinhwang91/rnvimr',
        config = function()
            vim.keymap.set('n', '<leader>ra', '<cmd>RnvimrToggle<CR>', { desc = "[R][a]nger" })
        end
    },
    {
        -- 使用 leader+i 快速反转一些值，如true/false
        'nguyenvukhang/nvim-toggler',
        config = function()
            -- init.lua
            require('nvim-toggler').setup({
                -- your own inverses
                inverses = {
                    ['vim'] = 'emacs'
                },
                -- removes the default <leader>i keymap
                remove_default_keybinds = false,
                -- removes the default set of inverses
                remove_default_inverses = false,
                -- auto-selects the longest match when there are multiple matches
                autoselect_longest_match = false,

                vim.keymap.set({ 'n', 'v' }, '<leader>i', require('nvim-toggler').toggle)
            })
        end
    },
    {
        -- gcc / gc + num 添加/取消注释
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({
                ---Add a space b/w comment and the line
                padding = true,
                ---Whether the cursor should stay at its position
                sticky = true,
                ---Lines to be ignored while (un)comment
                ignore = nil,
                ---LHS of toggle mappings in NORMAL mode
                toggler = {
                    ---Line-comment toggle keymap
                    line = 'gcc',
                    ---Block-comment toggle keymap
                    block = 'gbc',
                },
                ---LHS of operator-pending mappings in NORMAL and VISUAL mode
                opleader = {
                    ---Line-comment keymap
                    line = 'gc',
                    ---Block-comment keymap
                    block = 'gb',
                },
                ---LHS of extra mappings
                extra = {
                    ---Add comment on the line above
                    above = 'gcO',
                    ---Add comment on the line below
                    below = 'gco',
                    ---Add comment at the end of line
                    eol = 'gcA',
                },
                ---Enable keybindings
                ---NOTE: If given `false` then the plugin won't create any mappings
                mappings = {
                    ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
                    basic = true,
                    ---Extra mapping; `gco`, `gcO`, `gcA`
                    extra = true,
                },
                ---Function to call before (un)comment
                pre_hook = nil,
                ---Function to call after (un)comment
                post_hook = nil,
            })
        end
    },
    {
        -- s/S 进行搜索
        -- 可以和 y v d c 等命令配合，如 dx{xx} 为删除到{xx}
        -- gs 多窗口搜索
        "ggandor/leap.nvim",
        config = function()
            require('leap').add_default_mappings()
        end
    },
    {
        -- search highlight
        -- push "Esc" to quit highlight
        "kevinhwang91/nvim-hlslens",
        event = "VeryLazy",
        config = function()
            local kopts = { noremap = true, silent = true }
            require('hlslens').setup({
                vim.api.nvim_set_keymap('n', 'n',
                    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
                    kopts),
                vim.api.nvim_set_keymap('n', 'N',
                    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
                    kopts),
                vim.api.nvim_set_keymap('n', '<Esc>', '<Cmd>noh<CR>', kopts),
            })
        end
    },
    {
        -- AutoSave
        "okuuva/auto-save.nvim",
        cmd = "ASToggle",          -- optional for lazy loading on command
        event = { "InsertLeave" }, -- optional for lazy loading on trigger events
        opts = {
            enabled = true,        -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
            execution_message = {
                enabled = true,
                message = function() -- message to print on save
                    return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
                end,
                dim = 0.18,                                                                 -- dim the color of `message`
                cleaning_interval = 1250,                                                   -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
            },
            trigger_events = {                                                              -- See :h events
                immediate_save = { "BufLeave", "FocusLost", "InsertLeave", "TextChanged" }, -- vim events that trigger an immediate save
                -- defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
                cancel_deferred_save = { "InsertEnter" },                                    -- vim events that cancel a pending deferred save
            },
            -- function that takes the buffer handle and determines whether to save the current buffer or not
            -- return true: if buffer is ok to be saved
            -- return false: if it's not ok to be saved
            -- if set to `nil` then no specific condition is applied
            condition = function(buf)
                local fn = vim.fn
                local utils = require("auto-save.utils.data")

                if utils.not_in(fn.getbufvar(buf, "&filetype"), { "lua" }) then
                    return true
                end

                return false
            end,
            write_all_buffers = false, -- write all buffers when the current one meets `condition`
            noautocmd = false,         -- do not execute autocmds when saving
            debounce_delay = 1000,     -- delay after which a pending save is executed
            -- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
            debug = false,
        }
    },
    {
        -- nvim-sorround
        -- add / delete / change can be done with keys: ys{motion}{char} / ds{char} / cs{target}{replacement}
        --     Old text                    Command         New text
        ----------------------------------------------------------------
        -- surr*ound_words             ysiw)           (surround_words)
        -- *make strings               ys$"            "make strings"
        -- [delete ar*ound me!]        ds]             delete around me!
        -- remove <b>HTML t*ags</b>    dst             remove HTML tags
        -- 'change quot*es'            cs'"            "change quotes"
        -- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
        -- delete(functi*on calls)     dsf             function calls
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        -- event = "VeryLazy",
        opts = {
            enable_check_bracket_line = false,
        },
    },
    {
        -- a:all,i:in,可以和vim的v,d等命令配合，如vi"(v in "")
        'echasnovski/mini.ai',
        event = "VeryLazy",
        config = true,
    },
    {
        -- tabout
        "kawre/neotab.nvim",
        event = "InsertEnter",
        act_as_tab = true,
        opts = {
            tabkey = "<c-l>",
            act_as_tab = true,
            behavior = "nested",
            pairs = {
                { open = "(", close = ")" },
                { open = "[", close = "]" },
                { open = "{", close = "}" },
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = "`", close = "`" },
                { open = "<", close = ">" },
                { open = "$", close = "$" },
            },
            exclude = {},
            smart_punctuators = {
                enabled = false,
                semicolon = {
                    enabled = false,
                    ft = { "cs", "c", "cpp", "java" },
                },
                escape = {
                    enabled = false,
                    triggers = {},
                },
            },
        }
    },
    {
        -- \fw快速跳转到任意窗口
        "s1n7ax/nvim-window-picker",
        event = "VeryLazy",
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    include_current_win = true,
                    bo = {
                        filetype = { "fidget", "neo-tree" }
                    }
                }
            })
            vim.keymap.set("n",
                "<leader>fw",
                function()
                    local window_number = require('window-picker').pick_window()
                    if window_number then vim.api.nvim_set_current_win(window_number) end
                end,
                { desc = "[F]ind[W]indow" }
            )
        end
    },
    {
        -- 打开文件后自动跳转到上次位置
        "ethanholz/nvim-lastplace",
        -- event = "VeryLazy",
        config = true,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = true,
    },
}
