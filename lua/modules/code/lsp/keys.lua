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

    -- Symbol jumping, driven by LSP document symbols (modules/code/lsp/symbols.lua).
    -- The second letter picks the kind and its case picks the direction, following
    -- the same convention as git's <leader>gn / <leader>gN. The kind groups are
    -- resolved per filetype inside the module, so these stay language-neutral.
    local function sym(group, direction)
        return function()
            require("modules.code.lsp.symbols").jump(direction, group, vim.v.count1)
        end
    end
    Map.nmap("<leader>sn", sym("all", "next"), "Next Symbol")
    Map.nmap("<leader>sN", sym("all", "prev"), "Previous Symbol")
    Map.nmap("<leader>sf", sym("funcs", "next"), "Next Function")
    Map.nmap("<leader>sF", sym("funcs", "prev"), "Previous Function")
    Map.nmap("<leader>st", sym("types", "next"), "Next Type")
    Map.nmap("<leader>sT", sym("types", "prev"), "Previous Type")

    -- full diagnostic message for the current line (inline text is disabled,
    -- see modules/code/lsp/config.lua)
    Map.nmap("<leader>d", vim.diagnostic.open_float, "Show Line Diagnostics")

    -- project-wide diagnostics list
    Map.nmap("<leader>t", "<cmd>Trouble diagnostics toggle<CR>", "Toggle Trouble")
end

return M
