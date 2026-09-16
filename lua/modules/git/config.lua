-- modules/git/config.lua

local M = {}

function M.gitsigns()
    require("gitsigns").setup()
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

return M
