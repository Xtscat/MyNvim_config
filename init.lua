-- init.lua
--
-- Load order:
--   options   -> vim settings (must run first, sets <leader>)
--   commands  -> user commands
--   keymaps   -> global keymaps
--   autocmds  -> global autocmds
--   lazy      -> plugin manager; pulls specs from lua/modules/<name>/spec.lua

require("core.options")
require("core.commands")
require("core.keymaps")
require("core.autocmds")
require("core.lazy")
