return {
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
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup {
                enabled = true,          -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
                execution_message = {
                    message = function() -- message to print on save
                        return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
                    end,
                    dim = 0.18,                                                             -- dim the color of `message`
                    cleaning_interval = 1250,                                               -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
                },
                trigger_events = { "InsertLeave", "TextChanged", "BufLeave", "FocusLost" }, -- vim events that trigger auto-save. See :h events
                -- function that determines whether to save the current buffer or not
                -- return true: if buffer is ok to be saved
                -- return false: if it's not ok to be saved
                condition = function(buf)
                    local fn = vim.fn
                    local utils = require("auto-save.utils.data")

                    if
                        fn.getbufvar(buf, "&modifiable") == 1 and
                        utils.not_in(fn.getbufvar(buf, "&filetype"), { 'lua' }) then
                        return true              -- met condition(s), can save
                    end
                    return false                 -- can't save
                end,
                write_all_buffers = true,        -- write all buffers when the current one meets `condition`
                debounce_delay = 135,            -- saves the file at most every `debounce_delay` milliseconds
                callbacks = {                    -- functions to be executed at different intervals
                    enabling = nil,              -- ran when enabling auto-save
                    disabling = nil,             -- ran when disabling auto-save
                    before_asserting_save = nil, -- ran before checking `condition`
                    before_saving = nil,         -- ran before doing the actual save
                    after_saving = nil           -- ran after doing the actual save
                }
            }
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    -- 添加包围 (Normal Mode): <Leader>sa
                    -- "sa" 可记为 "Surround Add"
                    -- 使用方法: <Leader>sa + 文本对象 + 包围符号
                    -- 示例 1: <Leader>saiw)  ->  给光标下的单词(word)加上圆括号 -> (word)
                    -- 示例 2: <Leader>sat"   ->  给整个HTML标签(tag)加上双引号 -> "<b>text</b>"
                    normal = "<Leader>sa",

                    -- 删除包围 (Normal Mode): <Leader>sd
                    -- "sd" 可记为 "Surround Delete"
                    -- 使用方法: <Leader>sd + 要删除的包围符号
                    -- 示例: <Leader>sd"  ->  删除光标内外围的双引号
                    delete = "<Leader>sd",

                    -- 更改/替换包围 (Normal Mode): <Leader>sr
                    -- "sr" 可记为 "Surround Replace"
                    -- 使用方法: <Leader>sr + 旧符号 + 新符号
                    -- 示例: <Leader>sr'"  ->  将外围的单引号(')替换为双引号(")
                    change = "<Leader>sr",

                    -- 添加包围 (Visual Mode): <Leader>s
                    -- 使用方法: 先用 v 或 V 选中一段文本, 然后按 <Leader>s, 最后输入你想要的包围符号
                    visual = "<Leader>s",
                },
            })
        end,
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
