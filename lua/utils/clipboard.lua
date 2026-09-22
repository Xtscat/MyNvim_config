-- utils/clipboard.lua
--
-- One place for "copy to clipboard" logic, so every copy path behaves the
-- same over ssh.
--
-- Background: TextYankPost only fires for yank/delete/change operators
-- (`y`, `d`, `x`, ...). Anything that writes a register directly via
-- vim.fn.setreg() never fires it -- so an OSC 52 autocmd alone misses
-- mappings like <leader>l. Route every copy through M.yank() instead.

local M = {}

-- True when Neovim is running inside an ssh session (i.e. the terminal on
-- the user's desk is not local, so yanks must travel over OSC 52).
M.is_ssh = (vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT or vim.env.SSH_TTY) ~= nil

-- Mirror `lines` (list of strings) to the local terminal via OSC 52.
function M.osc52(lines, reg)
    require("vim.ui.clipboard.osc52").copy(reg or "+")(lines)
end

-- Copy `text` (string or list of lines) into a register. Under ssh the text
-- is additionally pushed over OSC 52 so it lands in the local clipboard.
function M.yank(text, reg)
    reg = reg or "+"
    vim.fn.setreg(reg, text)
    if M.is_ssh then
        M.osc52(type(text) == "table" and text or { text }, reg)
    end
end

return M
