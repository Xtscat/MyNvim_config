-- modules/editor/config.lua
--
-- Setup for the editing-experience plugins (no LSP, no UI chrome).

local M = {}

-- Comment.nvim options. Handed to lazy via the spec's `opts`, which calls
-- require("Comment").setup(M.comment) for us.
-- (The old config returned this table from a function that was never called,
-- so Comment never actually got these options.)
M.comment = {
    padding = true, -- keep one space after the comment leader
    sticky = true,  -- keep the cursor position when commenting
    toggler = {
        line = "gcc",  -- toggle current line
        block = "gbc", -- toggle current block
    },
    opleader = {
        line = "gc",  -- gc<motion> operator
        block = "gb",
    },
    extra = {
        above = "gcO", -- insert a comment above
        below = "gco",
        eol = "gcA",   -- append a comment at end of line
    },
    mappings = {
        basic = true,
        extra = true,
    },
}

-- neotab: make <Tab> indent when it makes sense, otherwise insert a tab.
function M.neotab()
    require("neotab").setup({
        tabkey = "<Tab>",
        reverse_key = "<S-Tab>",
        act_as_tab = true,
        behavior = "nested",
        -- pairs that make <Tab> "jump out" instead of inserting a tab
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

-- nvim-toggler: flip words like true<->false on a keymap.
function M.toggler()
    require("nvim-toggler").setup({
        inverses = {
            ["vim"] = "emacs", -- extra custom pair
        },
        remove_default_keybinds = false,
        remove_default_inverses = false,
        autoselect_longest_match = false,
    })
end

-- auto-save: write the buffer on certain events.
function M.autosave()
    require("auto-save").setup({
        enabled = true,
        execution_message = {
            message = function() return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")) end,
            dim = 0.18,
            cleaning_interval = 1250,
        },
        trigger_events = { "InsertLeave", "TextChanged", "BufLeave", "FocusLost" },
        -- Only save "normal" buffers: skip non-modifiable ones (terminals,
        -- quickfix, ...) and lua (so it doesn't save half-edited config).
        condition = function(buf)
            local fn = vim.fn
            local utils = require("auto-save.utils.data")
            return fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), { "lua" })
        end,
        write_all_buffers = true,
        debounce_delay = 135,
    })
end

return M
