-- modules/git/keys.lua

local Map = require("utils.map").with_prefix("Git")
local M = {}

function M.register()
    -- git-conflict
    Map.nmap("<leader>gn", function() require("git-conflict").find_next() end, "Next Conflict")
    Map.nmap("<leader>gN", function() require("git-conflict").find_prev() end, "Prev Conflict")
    Map.nmap("<leader>go", function() require("git-conflict").choose("ours") end, "Choose Ours")
    Map.nmap("<leader>gt", function() require("git-conflict").choose("theirs") end, "Choose Theirs")
    Map.nmap("<leader>gb", function() require("git-conflict").choose("both") end, "Choose Both")
    Map.nmap("<leader>gx", function() require("git-conflict").choose("none") end, "Choose None")
end

return M
