return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "nvimdev/lspsaga.nvim",
        {
            "folke/trouble.nvim",
            opts = {}
        },
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
            ruff_lsp = {},
            jedi_language_server = {},

            -- bash
            bashls = {},
        }
        local on_attach = function(_, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            local nmap = function(keys, func, desc)
                if desc then
                    desc = 'LSP: ' .. desc
                end

                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            -- gd 跳转到变量定义
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('gd', require "telescope.builtin".lsp_definitions, '[G]oto [D]efinition')
            -- nmap('gd', "<cmd>Lspsaga peek_definition<cr>", '[G]oto [D]eclaration')
            -- nmap('gD', "<cmd>Lspsaga peek_type_definition<cr>", '[G]oto [D]efinition')
            -- K 显示文档
            nmap('K', "<cmd>Lspsaga hover_doc<cr>", 'Hover Documentation')
            -- gi 快速跳转到变量声明
            nmap('gi', require "telescope.builtin".lsp_implementations, '[G]oto [I]mplementation')
            -- <leader>da 显示代码中所有错误及警告
            -- nmap('<leader>da', require "telescope.builtin".diagnostics, '[D]i[A]gnostics')
            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            -- <leader>wl 显示当前文件路径
            nmap('<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')
            nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
            -- <leader>rn 更给变量名称 <c-k>退出窗口
            nmap('<leader>rn', "<cmd>Lspsaga rename ++project<cr>", '[R]e[n]ame')
            -- <leader>ca 显示当前代码可执行行为
            nmap('<leader>ca', "<cmd>Lspsaga code_action<cr>", '[C]ode [A]ction')
            -- gr 快速跳转到引用此变量的地方
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            -- nmap("<c-l>", function()
            --     vim.lsp.buf.format()
            -- end, "[F]ormat code")
            -- nmap('<leader>a', "<cmd>Lspsaga outline<cr>", 'LspSaga Outline')
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
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(servers),
        })
        -- require("lsp-lens").setup({
        --     enable = true,
        --     include_declaration = true, -- Reference include declaration
        --     sections = {                -- Enable / Disable specific request, formatter example looks 'Format Requests'
        --         definition = true,
        --         references = true,
        --         implements = true,
        --         git_authors = true,
        --     },
        --     ignore_filetype = {
        --         -- "lua",
        --     },
        -- })
        require("lsp-progress").setup()

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
