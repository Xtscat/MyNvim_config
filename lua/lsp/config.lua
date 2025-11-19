-- lsp/config.lua

local M = {}

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
        clangd = {},

        -- for python
        ruff = {},
        jedi_language_server = {},

        -- for bash
        bashls = {
            bash = {
                diagnostics = { enable = true },
                completion = { enable = true },
            },
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
    require("blink.cmp").setup({
        completion = {
            keyword = { range = 'full' },
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
    })
end

function M.lspsaga_config()
    require("lspsaga").setup({
        lightbulb = {
            enable = false
        },
        rename = {
            in_select = true,
            auto_save = true,
            keys = {
                quit = '<C-k>',
            }
        }
    })
end

function M.mason_config()
    require("mason").setup()
end

function M.fidget_config()
    require('fidget').setup({})
    -- -- CodeCompanion 状态显示逻辑
    -- local handler
    -- vim.api.nvim_create_autocmd({ "User" }, {
    --     pattern = "CodeCompanionRequest*",
    --     group = vim.api.nvim_create_augroup("CodeCompanionFidget", { clear = true }),
    --     callback = function(request)
    --         local fidget = require("fidget")
    --         if not fidget then
    --             return
    --         end
    --
    --         if request.match == "CodeCompanionRequestStarted" then
    --             if handler then
    --                 handler:cancel()
    --                 handler = nil
    --             end
    --             handler = fidget.progress.handle.create({
    --                 title = "CodeCompanion",
    --                 message = "Progressing...",
    --                 lsp_client = { name = "CodeCompanion" },
    --             })
    --         elseif request.match == "CodeCompanionRequestFinished" then
    --             if handler then
    --                 handler:finish()
    --                 handler = nil
    --             end
    --         end
    --     end,
    -- })
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
            typescript = { 'prettier' },
            html = { 'prettier' },
            css = { 'prettier' },
            markdown = { 'prettier' }
        },
        notify_on_error = true,
        formatters = {
            clang_format = {
                args = { "--style={BasedOnStyle: google, IndentWidth: 4, ColumnLimit: 120, AllowShortBlocksOnASingleLine: Empty, AllowShortFunctionsOnASingleLine: Empty, IndentAccessModifiers: false, AccessModifierOffset: -2, PointerAlignment: Left}" }
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

return M
