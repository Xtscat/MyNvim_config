-- configs/hex.lua

local M = {}
local Map = require("utils.map").with_prefix("Hex")

function M.hex_config()
    require("hexinspector").setup({
        bytes_per_line = 24,
    })
end

function M.hex_keymaps()
    Map.nmap(
        "<leader>z",
        function()
            vim.ui.input({ prompt = "File path: ", default = vim.fn.expand("%:p") }, function(input)
                if input and input ~= "" then
                    require("hexinspector").open(input)
                end
            end)
        end,
        "Hex Editor (Pick File)"
    )
end

return M
