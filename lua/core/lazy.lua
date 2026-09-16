-- core/lazy.lua
--
-- Bootstraps lazy.nvim (the plugin manager) and starts it.
--
-- The actual plugin list is NOT here: `require("modules").specs()` walks the
-- `order` list in lua/modules/init.lua and concatenates every module's
-- spec.lua. So to add/remove plugins you edit a module, not this file.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- First run on a fresh machine: clone lazy.nvim itself.
-- NOTE: this needs network + git. Air-gapped installs must ship this directory.
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none", -- partial clone: skip blobs, much faster
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- All plugin specs, gathered from lua/modules/*/spec.lua.
    spec = require("modules").specs(),
    -- Every plugin loads at startup unless its spec sets event/cmd/ft/keys.
    -- (Plugins that do set those become lazy-loaded.)
    defaults = { lazy = false },
    -- Don't poll GitHub for plugin updates; keeps startup offline-safe.
    checker = { enabled = false },
})
