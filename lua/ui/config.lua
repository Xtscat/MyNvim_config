-- ui/config.lua

local M = {}

function M.sunset_config()
    local onedark = require('onedark')
    require('sunset').setup({
        latitude = 36.31,
        longitude = 104.48,
        day_callback = function()
            vim.opt.background = 'light'
            vim.g.edge_style = 'aura'
            vim.cmd.colorscheme('edge')
            -- vim.cmd.colorscheme('dawnfox')
        end,

        night_callback = function()
            vim.opt.background = 'dark'
            onedark.style = 'warmer'
            vim.cmd.colorscheme('onedark')
        end
    })
end

function M.treesitter_config()
    require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "cpp", "python", "bash", "html", "lua", "markdown", "markdown_inline" },
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        },
    }
end

function M.nvim_scrollview_config()
    require('scrollview').setup({
        excluded_filetypes = { 'neotree' },
        current_only = true,
        -- base = 'buffer',
        -- column = 80,
        signs_on_startup = { 'all' },
        scrollview_base = 'right',
        scrollview_signs_overflow = 'right',
        scrollview_folds_symbol = { 'right' },
        scrollview_textwidth_symbol = { 'right' },
        diagnostics_severities = { vim.diagnostic.severity.ERROR }
    })
end

function M.indent_blankline_config()
    require("ibl").setup({
        indent = {
            char = { '╎' },
            smart_indent_cap = true,
        },
        scope = {
            show_start = false,
            show_end = false,
            highlight = { "Function", "Label" }
        }
    })
end

function M.nvim_cursorline_config()
    require('nvim-cursorline').setup {
        cursorline = {
            enable = false,
            timeout = 50,
            number = true,
        },
        cursorword = {
            enable = true,
            min_length = 3,
            hl = {
                underline = true
            },
        }
    }
end

function M.lualine_config()
    require('lualine').setup({
        options = {
            -- theme = 'catppuccin',
            globalstatus = true,
            always_show_tabline = true,
        },
        sections = {
            lualine_c = {
                function()
                    return require('lsp-progress').progress()
                end
            },
            lualine_z = {
                {
                    require("opencode").statusline,
                },
            }
        }
    })
    vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh
    })
end

function M.barbar_config()
    require("barbar").setup({
        icons = {
            buffer_index = true,
            buffer_numbers = true,
        },
    })
end

function M.edgy_config()
    require("edgy").setup({
        animate = { enabled = false },
        close_when_all_hidden = true,
        exit_when_last = true,
        wo = { winbar = false },
        left = {
            {
                ft = "neo-tree",
                pinned = true,
                collapsed = false,
                size = { height = 0.5, width = 0.12 },
                open = "Neotree show"
            },
            {
                ft = "Outline",
                pinned = true,
                collapsed = false,
                size = { height = 0.5, width = 0.12 },
                open = "Outline"
            }
        },
        bottom = {
            {
                ft = 'toggleterm',
                size = { height = 0.3 },
                filter = function(_, win)
                    local cfg = vim.api.nvim_win_get_config(win)
                    local term = require("toggleterm.terminal").get(1)
                    return cfg.relative == "" and term.direction == "horizontal"
                end
            },
            {
                ft = 'trouble',
                size = { height = 0.3 },
                open = 'Trouble diagnostics toggle',
            }
        },
        right = {
            {
                ft = "codecompanionchat",
                size = { width = 0.3 },
                collapsed = false,
                open = "CodeCompanionChat Toggle",
            }
        }
    })
end

return M
