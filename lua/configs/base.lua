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
    vim.api.nvim_set_hl(0, "SnacksPickerCursorline", { bg = "#2a2e38" })
    vim.api.nvim_set_hl(0, "SnacksPickerBorder", { link = "FloatBorder" })
    require("snacks").setup({
        input = { enabled = true },
        terminal = { enabled = true },
        lazygit = { configure = true },
        notify = { enabled = false },
        notifier = {
            enabled = false,
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
        picker = {
            enabled = true,
            -- 布局预设：左右分栏，右侧预览
            -- layout = {
            --     preset = "ivy", -- 你也可以用 "minimal" / "vertical" 等
            --     width = 0.9,
            --     height = 0.85,
            --     preview = "right",
            -- },
            -- 统一的边框/背景等窗口样式
            -- win = {
            --     backdrop = { enabled = true, blend = 10 }, -- 半透明背景
            --     input = {
            --         border = "rounded",
            --         title = " Search ",
            --         title_pos = "center",
            --         row = 1,
            --         padding = { 1, 2 },
            --         winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            --     },
            --     list = {
            --         border = "rounded",
            --         title = " Results ",
            --         title_pos = "center",
            --         winhighlight = table.concat({
            --             "Normal:NormalFloat",
            --             "FloatBorder:FloatBorder",
            --             "CursorLine:SnacksPickerCursorline",
            --         }, ","),
            --     },
            --     preview = {
            --         border = "rounded",
            --         title = " Preview ",
            --         title_pos = "center",
            --         winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            --     },
            -- },
            -- source = {
            --     files = { hidden = true },
            --     explorer = {
            --         layout = {
            --             auto_hide = { "input" },
            --         },
            --     },
            -- }
        },
        explorer = {
            enabled = true,
            replace_netrw = true, -- 替换 netrw
            layout = {
                preset = "sidebar",
                preview = false, -- 不要预览窗
                auto_hide = { "input" },
            },
            git = { enabled = true },
            columns = { "icon", "git", "name" },
            sort = { dirs_first = true },
            -- 可选：顶部状态栏
            win = {
                -- 给 Edgy 可识别的 filetype
                list = { bo = { filetype = "snacks_explorer" } },
                preview = { bo = { filetype = "snacks_explorer_preview" } },
            },
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
    -- file explorer
    Map.nmap('tt', function() Snacks.explorer({ focus = true }) end, 'File explorer')
end

return M
