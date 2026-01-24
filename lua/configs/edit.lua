-- configs/edit.lua

local M = {}
local Map = require("utils.map").with_prefix("Edit")

function M.comment_config()
    return {
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
            line = 'gcc',
            block = 'gbc',
        },
        opleader = {
            line = 'gc',
            block = 'gb',
        },
        extra = {
            above = 'gcO',
            below = 'gco',
            eol = 'gcA',
        },
        mappings = {
            basic = true,
            extra = true,
        },
        pre_hook = nil,
        post_hook = nil,
    }
end

function M.neotab_config()
    require('neotab').setup({
        tabkey = "<Tab>",
        reverse_key = "<S-Tab>",
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
    })
end

function M.nvim_toggler_config()
    require('nvim-toggler').setup({
        inverses = {
            ['vim'] = 'emacs'
        },
        remove_default_keybinds = false,
        remove_default_inverses = false,
        autoselect_longest_match = false,
    })
end

function M.hlslens_config()
    require("hlslens").setup({})
end

function M.autosave_config()
    require("auto-save").setup {
        enabled = true,
        execution_message = {
            message = function()
                return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
            end,
            dim = 0.18,
            cleaning_interval = 1250,
        },
        trigger_events = { "InsertLeave", "TextChanged", "BufLeave", "FocusLost" },
        condition = function(buf)
            local fn = vim.fn
            local utils = require("auto-save.utils.data")

            if
                fn.getbufvar(buf, "&modifiable") == 1 and
                utils.not_in(fn.getbufvar(buf, "&filetype"), { 'lua' }) then
                return true
            end
            return false
        end,
        write_all_buffers = true,
        debounce_delay = 135,
        callbacks = {
            enabling = nil,
            disabling = nil,
            before_asserting_save = nil,
            before_saving = nil,
            after_saving = nil
        }
    }
end

function M.nvim_surround_keymaps()
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
end

function M.hlslens_keymaps()
    Map.nmap('n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], "Next Match")
    Map.nmap('N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], "Prev Match")
    Map.nmap('<Esc>', '<Cmd>noh<CR>', "Clear Highlight")
end

return M
