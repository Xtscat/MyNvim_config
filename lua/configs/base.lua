local M = {}
local Map = require("utils.map").with_prefix("Base")

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

function M.snacks_config()
    vim.api.nvim_set_hl(0, "SnacksIndentGray", { fg = "#31353F" })
    require("snacks").setup({
        input = { enabled = true },
        picker = { enabled = true },
        terminal = { enabled = true },
        lazygit = { configure = true },
        notifier = {
            enabled = true,
            style = {
                anchor = "bottom_right"
            }
        },
        scroll = {
            animate = {
                duration = { step = 10, total = 200 },
                easing = "linear",
            },
            -- faster animation when repeating scroll after delay
            animate_repeat = {
                delay = 50, -- delay in ms before using the repeat animation
                duration = { step = 5, total = 50 },
                easing = "linear",
            },
            -- what buffers to animate
            filter = function(buf)
                return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and
                    vim.bo[buf].buftype ~= "terminal"
            end,
        },
    })
end

function M.snacks_keymaps()
    -- find
    Map.map({ "n", "x" }, "<leader>ff", function() Snacks.picker.files() end, "[F]ind [F]iles")
    Map.map({ "n", "x" }, "<leader>fc", function() Snacks.picker.grep() end, "[F]ind [C]ode")
    -- lsp
    Map.nmap('gd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
    Map.nmap('gD', function() Snacks.picker.lsp_type_definitions() end, '[G]oto Type [D]efinition')
    Map.nmap('gr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
    Map.nmap('gR', function() Snacks.picker.lsp_implementations() end, '[G]oto [R]ealization')
    Map.nmap("<leader>rn", vim.lsp.buf.rename, 'Lsp Rename')
    -- lazygit
    Map.nmap('<leader>lg', function() Snacks.lazygit.open() end, '[L]azy[G]it')
end

return M
