-- modules/code/lsp/keys.lua
--
-- LSP keymaps, registered once at startup. `Snacks.*` is only touched when a
-- key is pressed, so it does not matter that snacks loads separately.

local Map = require("utils.map").with_prefix("LSP")
local M = {}

function M.register()
    -- Go-to actions shown through the snacks picker
    Map.nmap("gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
    Map.nmap("gD", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
    Map.nmap("gr", function() Snacks.picker.lsp_references() end, "Goto References")
    Map.nmap("gR", function() Snacks.picker.lsp_implementations() end, "Goto Implementations")

    Map.nmap("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")

    -- full diagnostic message for the current line (inline text is disabled,
    -- see modules/code/lsp/config.lua)
    Map.nmap("<leader>d", vim.diagnostic.open_float, "Show Line Diagnostics")

    -- project-wide diagnostics list
    Map.nmap("<leader>t", "<cmd>Trouble diagnostics toggle<CR>", "Toggle Trouble")
end

return M
