return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "nvimdev/lspsaga.nvim",
    },
    config = function()
        -- 检查 Neovim 版本
        if vim.fn.has('nvim-0.11') == 0 then
            vim.notify("nvim-lspconfig requires Neovim 0.11+. Please upgrade Neovim.", vim.log.levels.WARN)
            return
        end

        -- 服务器配置定义
        local servers = {
            -- lua
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        diagnostics = { globals = { 'vim' } },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = { enable = false }
                    }
                }
            },

            -- c & cpp
            clangd = {},

            -- python
            ruff = {},
            jedi_language_server = {},

            -- bash
            bashls = {
                settings = {
                    bash = {
                        diagnostics = { enable = true },
                        completion = { enable = true },
                    },
                }
            },
        }

        -- LSP attach 回调函数
        local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            local nmap = function(keys, func, desc)
                if desc then
                    desc = 'LSP: ' .. desc
                end
                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            -- 键位绑定（保持不变）
            nmap('gd', require "telescope.builtin".lsp_definitions, '[G]oto [D]efinition')
            nmap('gD', require "telescope.builtin".lsp_type_definitions, '[G]oto Type [D]efinition')
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gi', require "telescope.builtin".lsp_implementations, '[G]oto [I]mplementation')
            nmap('gt', "<cmd>Telescope diagnostics bufnr=0 severity_bound=0<cr>", '[G]oto [T]roubles in current buffer')
            nmap('gT', "<cmd>Telescope diagnostics severity_bound=0<cr>", '[G]oto [T]roubles in all buffers')
            nmap('<leader>K', "<cmd>Lspsaga hover_doc<cr>", 'Hover Documentation')
            nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')
            nmap('<leader>rn', "<cmd>Lspsaga rename ++project<cr>", '[R]e[n]ame')
            nmap('<leader>ca', "<cmd>Lspsaga code_action<cr>", '[C]ode [A]ction')
        end

        -- 设置 lspsaga
        require("lspsaga").setup({
            lightbulb = {
                enable = false
            },
        })

        -- 设置 mason
        require("mason").setup()

        -- 获取 capabilities
        local base_capabilities = vim.lsp.protocol.make_client_capabilities()
        local capabilities = require('blink.cmp').get_lsp_capabilities(base_capabilities)

        -- 配置诊断显示
        vim.diagnostic.config({
            float = { border = "rounded" },
            virtual_text = { prefix = "●" },
            severity_sort = true,
        })

        -- 使用新的 API 配置每个服务器
        for server_name, config in pairs(servers) do
            -- 合并默认配置
            local server_config = vim.tbl_deep_extend("force", {
                capabilities = capabilities,
            }, config)

            -- 使用新的 vim.lsp.config API
            vim.lsp.config(server_name, server_config)

            -- 启用服务器
            vim.lsp.enable(server_name)
        end

        -- 设置全局 LSP attach 回调
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if client then
                    on_attach(client, ev.buf)
                end
            end,
        })
    end,
}
