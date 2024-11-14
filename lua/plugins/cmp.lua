return {
    "hrsh7th/nvim-cmp",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "onsails/lspkind.nvim",
        "hrsh7th/cmp-cmdline",
        "windwp/nvim-autopairs",
        {
            "saadparwaiz1/cmp_luasnip",
            dependencies = {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                run = "make install_jsregexp",
                dependencies = {
                    "rafamadriz/friendly-snippets"
                },
            }
        }
    },
    vim.keymap.set("n", "<leader>tr", function() require("trouble").open() end, { desc = "[T][R]ouble" }),
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')

        -- local has_words_before = function()
        --     unpack = unpack or table.unpack
        --     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        --     return col ~= 0 and
        --         vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        -- end
        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    require 'luasnip'.lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            window = {
                -- completion = {
                --     -- border = { "", "", "", "", "", "", "", "" },
                --     col_offset = -3,
                --     scrollbar = true,
                --     scrolloff = 0,
                --     side_padding = 1,
                --     winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None"
                -- },
                -- documentation = {
                --     -- border = { "", "", "", " ", "", "", "", " " }
                --     max_height = 28,
                --     max_width = 32,
                --     winhighlight = "FloatBorder:NormalFloat"
                -- },
                -- completion = {
                --     -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                --     col_offset = -3,
                --     side_padding = 1,
                -- },
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
                max_width = 30,
                scrollbar = true,
                side_padding = 5,
            },
            formatting = {
                format = lspkind.cmp_format({
                    maxwidth = 32,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    show_labelDetails = false,
                    mode = "symbol",
                    menu = ({
                        buffer = "[Buf]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snip]",
                        latex_symbols = "[Tex]",
                    }),
                    symbol_map = {
                        Text = "󰉿",
                        Method = "󰆧",
                        Function = "󰊕",
                        Constructor = "",
                        Field = "󰜢",
                        Variable = "󰀫",
                        Class = "󰠱",
                        Interface = "",
                        Module = "",
                        Property = "󰜢",
                        Unit = "󰑭",
                        Value = "󰎠",
                        Enum = "",
                        Keyword = "󰌋",
                        Snippet = "",
                        Color = "󰏘",
                        File = "󰈙",
                        Reference = "󰈇",
                        Folder = "󰉋",
                        EnumMember = "",
                        Constant = "󰏿",
                        Struct = "󰙅",
                        Event = "",
                        Operator = "󰆕",
                        TypeParameter = "",
                    }
                })
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'path' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            }),
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.close(),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- they way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif luasnip.jumpable(1) then
                        luasnip.jump(1)
                        -- elseif has_words_before() then
                        --     cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ['<CR>'] = cmp.mapping.confirm({ select = true })
            }),
        })
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' },
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' },
                { name = 'cmdline' }
            })
        })
    end
}
