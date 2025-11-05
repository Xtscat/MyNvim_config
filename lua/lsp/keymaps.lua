-- lsp/keymaps.lua

local M = {}

function M.lsp_keymaps()
    local on_attach = function(_client, bufnr)
        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        -- 键位绑定
        nmap('gd', "<cmd>Telescope lsp_definitions<CR>", '[G]oto [D]efinition')
        nmap('gD', "<cmd>Telescope lsp_type_definitions<CR>", '[G]oto Type [D]efinition')
        nmap('gr', "<cmd>Telescope lsp_references<CR>", '[G]oto [R]eferences')
        nmap('gR', "<cmd>Telescope lsp_implementations<CR>", '[G]oto [R]ealization')
        nmap('gt', "<cmd>Trouble diagnostics toggle<CR>", '[G]oto [T]rouble')
        nmap('<leader>K', "<cmd>Lspsaga hover_doc<cr>", 'Hover Documentation')
        nmap('<leader>rn', "<cmd>Lspsaga rename ++project<cr>", '[R]e[n]ame')
        nmap('<leader>ca', "<cmd>Lspsaga code_action<cr>", '[C]ode [A]ction')
    end

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client then
                on_attach(client, ev.buf)
            end
        end,
    })
end

function M.blink_keymaps()
    require("blink.cmp").setup({
        keymap = {
            preset = 'none',
            ['<C-space>'] = { 'hide' },
            ['<CR>'] = { 'select_and_accept', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
            ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        },
    })
end

function M.conform_keymaps()
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { desc = desc })
    end

    nmap("<c-l>", "<cmd>Format<CR>", "Code Format")
end

return M
