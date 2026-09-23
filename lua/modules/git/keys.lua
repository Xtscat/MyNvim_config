-- modules/git/keys.lua

local Map = require("utils.map").with_prefix("Git")
-- Conflicts get their own (shifted) prefix so <leader>g stays free for the hunk
-- navigation below.
local Conflict = require("utils.map").with_prefix("Git Conflict")
local M = {}

function M.register()
    -- gitsigns: jump to the next / previous change in the buffer. `target =
    -- "all"` covers staged and unstaged hunks -- with gitsigns' default
    -- ("unstaged") a file whose changes are all staged would look like it had
    -- none. wrap / navigation message / count follow 'wrapscan', 'shortmess'
    -- and v:count1.
    Map.nmap("<leader>gn", function() require("gitsigns").nav_hunk("next", { target = "all" }) end, "Next Change")
    Map.nmap("<leader>gN", function() require("gitsigns").nav_hunk("prev", { target = "all" }) end, "Previous Change")

    -- git-conflict
    Conflict.nmap("<leader>Gn", function() require("git-conflict").find_next() end, "Next Conflict")
    Conflict.nmap("<leader>GN", function() require("git-conflict").find_prev() end, "Previous Conflict")
    Conflict.nmap("<leader>Go", function() require("git-conflict").choose("ours") end, "Choose Ours")
    Conflict.nmap("<leader>Gt", function() require("git-conflict").choose("theirs") end, "Choose Theirs")
    Conflict.nmap("<leader>Gb", function() require("git-conflict").choose("both") end, "Choose Both")
    Conflict.nmap("<leader>Gx", function() require("git-conflict").choose("none") end, "Choose None")
end

return M
