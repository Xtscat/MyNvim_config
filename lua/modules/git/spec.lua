-- modules/git/spec.lua
--
-- Version control. Grouped by domain (not by where things render): gitsigns
-- draws in the sign column, but it belongs here, not in ui.

local C = "modules.git.config"
local function cfg(fn)
    return function() require(C)[fn]() end
end

return {
    { "lewis6991/gitsigns.nvim", config = cfg("gitsigns") },
    { "akinsho/git-conflict.nvim", config = cfg("git_conflict") },
}
