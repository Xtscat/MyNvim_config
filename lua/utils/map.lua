-- utils/map.lua
local M = {}

M.map = function(mode, lhs, rhs, desc, opts)
    local options = { noremap = true, silent = true }
    if desc then options.desc = desc end
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.keymap.set(mode, lhs, rhs, options)
end

function M.with_prefix(prefix)
    local helper = {}
    local modes = {
        nmap = "n",
        vmap = "v",
        imap = "i",
        xmap = "x",
        tmap = "t",
    }

    -- 【修复】简化逻辑，只检查 prefix 和 desc 是否存在
    helper.map = function(mode, lhs, rhs, desc, opts)
        local full_desc = desc
        if prefix and desc then
            full_desc = prefix .. ": " .. desc
        end
        M.map(mode, lhs, rhs, full_desc, opts)
    end

    for func_name, mode in pairs(modes) do
        helper[func_name] = function(lhs, rhs, desc, opts)
            local full_desc = desc
            if prefix and desc then
                full_desc = prefix .. ": " .. desc
            end
            M.map(mode, lhs, rhs, full_desc, opts)
        end
    end

    return helper
end

-- 【修复】传入 nil 而不是空字符串
local default = M.with_prefix(nil) -- 或者 M.with_prefix()
M.nmap = default.nmap
M.vmap = default.vmap
M.imap = default.imap
M.xmap = default.xmap
M.tmap = default.tmap

return M
