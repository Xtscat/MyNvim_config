-- lua/modules/init.lua
--
-- Module contract
-- ---------------
-- Each feature is a directory under lua/modules/. Files:
--
--   spec.lua    (required) returns a list of lazy.nvim plugin specs.
--   config.lua  (optional) returns a table of setup functions. spec.lua wires
--               them via `config = function() require("modules.<x>.config").fn() end`.
--   keys.lua    (optional) returns { register = function() ... end }. It is
--               called once at startup, so cross-plugin / eager keymaps get
--               registered regardless of when (or whether) a plugin loads.
--
-- `order` is the single source of truth for load order. Adding a module means
-- adding its directory and one line here. Failures are loud on purpose.

local M = {}

local order = {
    "deps",
    "snacks",
    "treesitter",
    "ui",
    "editor",
    "nav",
    "git",
    "code.completion",
    "code.lsp",
    "code.format",
    "ft.markdown",
    "build",
}

local function file_exists(path)
    return vim.uv.fs_stat(path) ~= nil
end

function M.specs()
    local out = {}
    local configdir = vim.fn.stdpath("config")

    for _, name in ipairs(order) do
        local mod = "modules." .. name
        local rel = name:gsub("%.", "/")

        if file_exists(configdir .. "/lua/modules/" .. rel .. "/keys.lua") then
            local keys = require(mod .. ".keys")
            if type(keys.register) == "function" then
                keys.register()
            end
        end

        local spec = require(mod .. ".spec")
        if type(spec) ~= "table" then
            error(("modules.%s.spec must return a table"):format(name))
        end
        vim.list_extend(out, spec)
    end

    return out
end

return M
