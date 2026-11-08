-- modules/git/config.lua

local M = {}

function M.gitsigns()
    require("gitsigns").setup({
        -- Files above 20MB carry the filetype "bigfile" (modules/snacks/config.lua)
        -- and must not get signs, highlights or an on_lines diff. gitsigns has no
        -- filetype filter of its own (attach.lua:119 only compares the line count
        -- with max_file_length) and detach() is async, racing the BufRead /
        -- BufWritePost attach it would have to undo, so the buffer is refused at
        -- gitsigns' own attach gate: on_attach() returning false aborts the attach
        -- (attach.lua:388-392) and every later BufWritePost ends up there again.
        on_attach = function(bufnr) return vim.bo[bufnr].filetype ~= "bigfile" end,
    })
    require("scrollbar.handlers.gitsigns").setup()
end

function M.git_conflict()
    require("git-conflict").setup({
        default_mappings = false, -- disable buffer-local mappings created by this plugin
        default_commands = false, -- disable commands created by this plugin
        disable_diagnostics = false,
        list_opener = "copen",
        highlights = {
            incoming = "DiffAdd",
            current = "DiffText",
        },
    })
end

-- While a diff tab is current, the scrollbar is switched off: diffbandit draws
-- its own minimap in the outermost column of every pane and splits the view into
-- a window per gutter, so nvim-scrollbar only manages to paint a second bar on
-- all of them, plus stray `•`/`┆` glyphs on the right edge of the code panes.
local function scrollbar_off()
    require("scrollbar.utils").hide()
    -- hide() repaints only the current window, and the panes drawn while the tab
    -- was being built keep their marks until their own buffer is cleared; clear
    -- the plugin's namespace in every window of this tab (its WinLeave/BufWinLeave
    -- autocmds do the same, one buffer at a time).
    local ns = vim.api.nvim_create_namespace(require("scrollbar.const").NAME_PREFIX)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        vim.api.nvim_buf_clear_namespace(vim.api.nvim_win_get_buf(win), ns, 0, -1)
    end
end

local function sync_scrollbar()
    if require("diffbandit").is_running({ tab = 0 }) then
        scrollbar_off()
    else
        require("scrollbar.utils").show()
    end
end

function M.diffbandit()
    require("diffbandit").setup({
        actions = {
            keys = {
                toggle_stage = "gs", -- 避免覆盖全局 <Space> (Leader)
            },
        },
        navigation = {
            document_keys = {
                top = "[D",         -- 避免覆盖全局 [d / ]d 诊断导航
                bottom = "]D",
            },
        },
        ui = {
            -- Glyph connectors, not Kitty images: the probe decides per terminal
            -- and the image path is what upstream #30 reports as silently blank.
            connector_renderer = "cells",
            theme = {
                change_emphasis_strength = 0.10,
            },
        },
    })

    local group = vim.api.nvim_create_augroup("DiffbanditView", { clear = true })

    -- diffbandit opens its view with `:tabnew` (diffbandit/session/layout.lua:449)
    -- and leaves the buffer that command creates listed and unnamed, so barbar
    -- paints it as a "[buffer N]" tab -- during the session and after it, one
    -- more for every launch. Unlist only that buffer, and only when a session has
    -- taken the tab, so a plain :tabnew keeps its empty buffer.
    vim.api.nvim_create_autocmd("TabNew", {
        group = group,
        callback = function()
            local tab = vim.api.nvim_get_current_tabpage()
            -- `:tabnew` fires TabNew before the tab gets its own buffer (the
            -- current buffer is still the one being left), so the leftover has to
            -- be found by diffing the buffer list against this snapshot.
            local known = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                known[buf] = true
            end
            -- the session is registered only after open() returns, i.e. after
            -- this event has finished
            vim.schedule(function()
                if not require("diffbandit").is_running({ tab = tab }) then
                    return
                end
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if
                        not known[buf]
                        and vim.api.nvim_get_option_value("buflisted", { buf = buf })
                        and vim.api.nvim_buf_get_name(buf) == ""
                        and #vim.fn.win_findbuf(buf) == 0
                    then
                        vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
                    end
                end
                sync_scrollbar()
            end)
        end,
    })

    vim.api.nvim_create_autocmd("TabEnter", { group = group, callback = sync_scrollbar })
    vim.api.nvim_create_autocmd("TabLeave", {
        group = group,
        callback = function()
            if require("diffbandit").is_running({ tab = 0 }) then
                require("scrollbar.utils").show()
            end
        end,
    })
end

return M
