-- core/commands.lua
--
-- Global user commands that do not belong to any single plugin.
-- (Commands that are just a plugin entry point are declared in that plugin's
-- spec.lua via `cmd = { ... }`, which also enables lazy-loading.)

-- Tab-completion helper for :Vsp / :Hsp.
-- Offers both names of currently open buffers and files in the current file's
-- directory, deduplicated and filtered by what has been typed so far.
local function complete(arg_lead)
    local seen, items = {}, {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
        if name ~= "" and not seen[name] and vim.startswith(name, arg_lead) then
            seen[name] = true
            items[#items + 1] = name
        end
    end
    local dir = vim.fn.expand("%:p:h")
    if dir ~= "" then
        for _, f in ipairs(vim.fn.readdir(dir)) do
            if not seen[f] and vim.startswith(f, arg_lead) then
                seen[f] = true
                items[#items + 1] = f
            end
        end
    end
    return items
end

-- Build a :Vsp or :Hsp command.
--   with an argument  -> open that buffer/file in a split
--   with no argument  -> pick from already-loaded, named buffers
--
-- `split_cmd` is the "split by buffer number" form, e.g. "vert sb " for
-- vertical. If that fails (the argument was a path, not a buffer), fall back
-- to "vsplit <file>".
local function make_split_cmd(name, split_cmd)
    vim.api.nvim_create_user_command(name, function(opts)
        local arg = vim.trim(opts.args)
        if arg ~= "" then
            local ok = pcall(vim.cmd, split_cmd .. arg)
            if not ok then
                local file_cmd = split_cmd == "vert sb " and "vsplit " or "split "
                vim.cmd(file_cmd .. arg)
            end
            return
        end

        -- No argument: pick from loaded, named buffers.
        local bufs = {}
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) ~= "" then
                bufs[#bufs + 1] = b
            end
        end
        -- vim.ui.select is overridden by snacks.input, so this opens the nice
        -- picker automatically; without snacks it falls back to a plain prompt.
        vim.ui.select(bufs, {
            prompt = "Open in split:",
            format_item = function(b) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":t") end,
        }, function(choice)
            if choice then
                vim.cmd(split_cmd .. choice)
            end
        end)
    end, { nargs = "?", complete = complete })
end

make_split_cmd("Vsp", "vert sb ")
make_split_cmd("Hsp", "sb ")

-- Make lowercase :vsp / :hsp expand to the commands above, but only when typed
-- as the exact command (so it does not interfere with e.g. `:vsp file`).
vim.cmd([[
    cnoreabbrev <expr> vsp getcmdtype() == ':' && getcmdline() == 'vsp' ? 'Vsp' : 'vsp'
    cnoreabbrev <expr> hsp getcmdtype() == ':' && getcmdline() == 'hsp' ? 'Hsp' : 'hsp'
]])
