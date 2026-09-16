-- utils/map.lua
--
-- Thin wrapper over vim.keymap.set.
--
-- Why wrap it at all: it (a) applies sane defaults (noremap + silent) and
-- (b) auto-prefixes the `desc` with a group name so keys show up grouped in
-- which-key. Example:
--
--     local Map = require("utils.map").with_prefix("Nav")
--     Map.nmap("tt", "<cmd>Neotree toggle<CR>", "Toggle File Tree")
--     -- desc becomes "Nav: Toggle File Tree"
--
-- Two call styles are accepted:
--     Map.nmap(lhs, rhs, "desc", opts)              -- explicit desc
--     Map.nmap(lhs, rhs, { buffer = true, desc = "..." })  -- vim.keymap.set style

local M = {}

-- The underlying setter.
M.map = function(mode, lhs, rhs, desc, opts)
    local options = { noremap = true, silent = true }
    if desc then
        options.desc = desc
    end
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Returns a table of helpers (nmap/vmap/imap/xmap/tmap/map) that all prepend
-- `prefix .. ": "` to the description.
function M.with_prefix(prefix)
    local helper = {}
    local modes = {
        nmap = "n",
        vmap = "v",
        imap = "i",
        xmap = "x",
        tmap = "t",
    }

    -- Normalise the two call styles above into (desc, opts).
    local function normalized(desc, opts)
        if type(desc) == "table" then
            -- vim.keymap.set style: desc is really the opts table.
            opts = vim.tbl_extend("force", {}, desc) -- copy, don't mutate caller's table
            desc = opts.desc
            opts.desc = nil -- let M.map set the prefixed desc instead
        end
        if prefix and desc then
            desc = prefix .. ": " .. desc
        end
        return desc, opts
    end

    -- helper.map(mode, lhs, rhs, ...) for an explicit mode.
    helper.map = function(mode, lhs, rhs, desc, opts)
        local d, o = normalized(desc, opts)
        M.map(mode, lhs, rhs, d, o)
    end

    -- helper.nmap(lhs, rhs, ...), helper.imap(...), etc.
    for func_name, mode in pairs(modes) do
        helper[func_name] = function(lhs, rhs, desc, opts)
            local d, o = normalized(desc, opts)
            M.map(mode, lhs, rhs, d, o)
        end
    end

    return helper
end

-- Convenience: prefix-free variants directly on the module (M.nmap, M.vmap...).
local default = M.with_prefix(nil)
M.nmap = default.nmap
M.vmap = default.vmap
M.imap = default.imap
M.xmap = default.xmap
M.tmap = default.tmap

return M
