-- configs/lsp.lua

local M = {}
local Map = require("utils.map").with_prefix("LSP")


function M.mason_config()
    require("mason").setup()
end

function M.lsp_config()
    local base_capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require('blink.cmp').get_lsp_capabilities(base_capabilities)
    local servers = {
        -- for Lua
        emmylua_ls = {
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true)
                    }
                }
            }
        },

        -- for c&cpp
        clangd = {
            cmd = {
                "clangd",
                "--background-index",
                "--completion-style=detailed",
                "--all-scopes-completion",
                "--header-insertion=iwyu",
            }
        },

        -- for python
        ruff = {},
        jedi_language_server = {},

        -- for bash
        bashls = {
            bash = {
                diagnostics = { enable = true },
                completion = { enable = true },
            },
        },

        -- for latex
        texlab = {
            filetypes = { "tex", "plaintex", "bib" }
        }
    }
    for server_name, config in pairs(servers) do
        local server_config = vim.tbl_deep_extend("force", {
            capabilities = capabilities,
        }, config)
        vim.lsp.config(server_name, server_config)
        vim.lsp.enable(server_name)
    end

    vim.diagnostic.config({
        float = { border = "rounded" },
        virtual_text = { prefix = "●" },
        severity_sort = true,
    })
end

function M.blink_config()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("blink.cmp").setup({
        snippets = {
            expand = function(snippet)
                require("luasnip").lsp_expand(snippet)
            end,
        },
        completion = {
            keyword = { range = 'full' },
            trigger = {
                show_on_trigger_character = true,
                show_on_blocked_trigger_characters = { ' ', '\n', '\t' }
            },
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
            list = { selection = { preselect = false, auto_insert = true } },
            menu = {
                draw = {
                    columns = {
                        { "kind_icon" }, { "label", "label_description", gap = 1 }
                    },
                    treesitter = { 'lsp' }
                },
            },
        },
        enabled = function()
            return not vim.tbl_contains({
                    -- "lua",
                    -- "markdown"
                }, vim.bo.filetype)
                and vim.bo.buftype ~= "prompt"
                and vim.b.completion ~= false
        end,
        appearance = {
            nerd_font_variant = 'mono'
        },
        sources = {
            default = { 'buffer', 'lsp', 'path', 'snippets' },
            providers = {
                lsp = { score_offset = 4 },
                snippets = { score_offset = 3 },
                path = { score_offset = 2 },
                buffer = { score_offset = 1 },
            },
        },
        cmdline = {
            completion = {
                menu = { auto_show = true },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        keymap = {
            preset = 'none',
            ['<C-space>'] = { 'hide' },
            ['<CR>'] = { 'select_and_accept', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
            ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        },
    })
end

function M.conform_config()
    require("conform").setup({
        -- map of filetype to formatters
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "yapf", "isort" },
            c = { "clang_format" },
            cpp = { "clang_format" },
            cuda = { "clang_format" },
            javascript = { 'prettier' },
            json = { 'biome' },
            typescript = { 'prettier' },
            html = { 'prettier' },
            css = { 'prettier' },
            markdown = { 'prettier' }
        },
        notify_on_error = true,
        formatters = {
            clang_format = {
                args = {
                    [[--style={
                        BasedOnStyle: google,
                        IndentWidth: 4,
                        ColumnLimit: 120,
                        AllowShortBlocksOnASingleLine: Empty,
                        AllowShortFunctionsOnASingleLine: Empty,
                        IndentAccessModifiers: false,
                        AccessModifierOffset: -2,
                        PointerAlignment: Left,
                    }]],
                },
            }
        },
        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            require("conform").format({ async = true, lsp_fallback = true, range = range })
        end, { range = true }),
    })
end

function M.fidget_config()
    require('fidget').setup({})
end

function M.trouble_config()
    require('trouble').setup({
        auto_preview = false
    })
end

function M.conform_keymaps()
    Map.nmap("<c-l>", "<cmd>Format<CR>", "Code Format")
end

function M.trouble_keymaps()
    Map.nmap("<leader>t", "<cmd>Trouble diagnostics toggle<CR>", "Trouble toggle")
end

return M
