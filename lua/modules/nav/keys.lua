-- modules/nav/keys.lua
--
-- Registered once at startup (see lua/modules/init.lua). Note that `Snacks.*`
-- and `require("haunt...")` are referenced at *call* time, so this file works
-- even though it runs before those plugins are loaded.

local Map = require("utils.map").with_prefix("Nav")
local M = {}

function M.register()
    -- snacks picker (files / live grep)
    Map.map({ "n", "x" }, "<leader>ff", function() Snacks.picker.files() end, "Find Files")
    Map.map({ "n", "x" }, "<leader>fc", function() Snacks.picker.grep() end, "Find Code")
    Map.nmap("<leader>fs", function() Snacks.picker.lsp_symbols() end, "Find Symbol")

    -- neo-tree
    Map.nmap("tt", "<cmd>Neotree toggle<CR>", "Toggle File Tree")
    Map.nmap("<leader>e", "<cmd>Neotree reveal<CR>", "Reveal Current File")

    -- outline (symbols)
    Map.nmap("<leader>a", "<cmd>Outline<CR>", "Toggle Outline")

    -- hlslens: keep hlslens' match counter/indicator when jumping between
    -- search hits, and clear the highlight with <Esc>. hlslens only has a
    -- module-level on/off switch and no per-buffer one (hlslens/main.lua:47-77),
    -- so a big file -- the filetype snacks give files above 20MB -- is kept out
    -- of the renderer here rather than by switching the plugin off for every
    -- other buffer. `normal!` stays in the mapping so a missing match still
    -- reports E486 as it did before.
    local function jump_matches(cmd)
        return (
            [[<Cmd>execute('normal! ' . v:count1 . '%s')<CR>]]
            .. [[<Cmd>lua if vim.bo.filetype ~= "bigfile" then require('hlslens').start() end<CR>]]
        ):format(cmd)
    end
    Map.nmap("n", jump_matches("n"), "Next Match")
    Map.nmap("N", jump_matches("N"), "Prev Match")
    Map.nmap("<Esc>", "<Cmd>noh<CR>", "Clear Search Highlight")

    -- haunt.nvim (ghost-text notes) -> <leader>n
    -- `haunt()` is a tiny accessor so we only require the module on use.
    local function haunt()
        return require("haunt.api")
    end
    Map.nmap("<leader>na", function() haunt().annotate() end, "Note: Add")
    Map.nmap("<leader>nt", function() haunt().toggle_annotation() end, "Note: Toggle Line")
    Map.nmap("<leader>nT", function() haunt().toggle_all_lines() end, "Note: Toggle All")
    Map.nmap("<leader>nd", function() haunt().delete() end, "Note: Delete")
    Map.nmap("<leader>nC", function() haunt().clear_all() end, "Note: Clear All")
    Map.nmap("<leader>np", function() haunt().prev() end, "Note: Previous")
    Map.nmap("<leader>nn", function() haunt().next() end, "Note: Next")
    Map.nmap("<leader>nl", function() require("haunt.picker").show() end, "Note: List")
    Map.nmap("<leader>nq", function() haunt().to_quickfix({ current_buffer = true }) end, "Note: To Quickfix (Buffer)")
    Map.nmap("<leader>nQ", function() haunt().to_quickfix() end, "Note: To Quickfix (All)")
    Map.nmap("<leader>ny", function() haunt().yank_locations({ current_buffer = true }) end, "Note: Copy Locations (Buffer)")
    Map.nmap("<leader>nY", function() haunt().yank_locations() end, "Note: Copy Locations (All)")
end

return M
