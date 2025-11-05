-- utils/markdown/keymaps.lua

local M = {}

local function nmap(keys, func, opts)
    opts = opts or {}
    if opts.desc then
        opts.desc = 'Markdown: ' .. opts.desc
    end
    vim.keymap.set('n', keys, func, opts)
end

local function imap(keys, func, opts)
    opts = opts or {}
    if opts.desc then
        opts.desc = 'Markwodn: ' .. opts.desc
    end
    vim.keymap.set('i', keys, func, opts)
end

function M.smark_keymaps()
    local group = vim.api.nvim_create_augroup('MarkdownSmarkOverrides', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = 'markdown',
        callback = function()
            vim.b.completion = false
            -- 使用新的 imap 函数
            imap('<Tab>', '<C-t>', {
                buffer = true,
                remap = true,
                desc = "Smark: Indent List"
            })
            imap('<S-Tab>', '<C-d>', {
                buffer = true,
                remap = true,
                desc = "Smark: Un-indent List"
            })
        end,
    })
end

return M
