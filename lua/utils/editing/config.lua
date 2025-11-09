-- utils/editing/config.lua

local M = {}

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

return M
