return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "nvimdev/lspsaga.nvim",
        "linrongbin16/lsp-progress.nvim",
    },
    config = function()
        local servers = {
            -- lua
            lua_ls = {
                settings = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false }
                    }
                }
            },
            -- c & cpp
            clangd = {},

            -- python
            -- pyright = {},
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
        local on_attach = function(_, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            local nmap = function(keys, func, desc)
                if desc then
                    desc = 'LSP: ' .. desc
                end

                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            -- gd: Goto the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope
            nmap('gd', require "telescope.builtin".lsp_definitions, '[G]oto [D]efinition')
            -- gD: Goto the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope
            nmap('gD', require "telescope.builtin".lsp_type_definitions, '[G]oto Type [D]efinition')
            -- gr: Lists LSP references for word under the cursor
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            -- gi: Goto the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope
            nmap('gi', require "telescope.builtin".lsp_implementations, '[G]oto [I]mplementation')
            -- gt: Goto error of warnings in the current buffer
            nmap('gt', "<cmd>Telescope diagnostics bufnr=0 severity_bound=0<cr>", '[G]oto [T]roubles in current buffer')
            -- gT: Goto error of warnings in all buffers
            nmap('gT', "<cmd>Telescope diagnostics severity_bound=0<cr>", '[G]oto [T]roubles in all buffers')
            -- <leader>K 显示文档
            nmap('<leader>K', "<cmd>Lspsaga hover_doc<cr>", 'Hover Documentation')
            -- <leader>k 显示当前函数帮助文档
            nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')
            -- <leader>rn 更给变量名称 <c-k>退出窗口
            nmap('<leader>rn', "<cmd>Lspsaga rename ++project<cr>", '[R]e[n]ame')
            -- <leader>ca 显示当前代码可执行行为
            nmap('<leader>ca', "<cmd>Lspsaga code_action<cr>", '[C]ode [A]ction')
        end

        require("lspsaga").setup({
            lightbulb = {
                enable = false
            },
            ui = {
                kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
            },
        })
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(servers),
        })
        require("lsp-progress").setup()

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        for server, config in pairs(servers) do
            require("lspconfig")[server].setup(
                vim.tbl_deep_extend("keep",
                    {
                        on_attach = on_attach,
                        capabilities = capabilities
                    },
                    config
                )
            )
        end
    end,
}
