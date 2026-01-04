local M = {}
local Map = require("utils.map").with_prefix("UI")

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

function M.lualine_config()
    local function lsp_name()
        local msg = "No Active LSP"
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local client = clients and clients[1]
        return (client and client.name) or msg
    end

    require('lualine').setup({
        options = {
            globalstatus = true,
            component_separators = '', -- 去掉组件之间的分隔符
            section_separators = '',   -- 去掉 section 之间的分隔符
        },
        sections = {
            --[[
            --  lualine_a: 左侧最左; lualine_b: 左边中间; lualine_c: 左边靠右
            --  lualine_x: 右边靠左; lualine_y: 右边中间; lualine_z: 右边靠右
            --]]
            lualine_a = { 'mode' },
            lualine_b = { 'filename', 'branch', 'diff' },
            lualine_c = {
                -- 'filename',
                -- { symbols.get, cond = symbols.has },
                { function() return "%=" end },
                { lsp_name, icon = " LSP:" },
                { 'diagnostics', sources = { 'nvim_diagnostic' } },
            },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location', { require("opencode").statusline } }
        },
    })
end

function M.dropbar_config()
    require("dropbar").setup()
end

function M.barbar_config()
    require("barbar").setup({
        icons = {
            buffer_index = true,
            buffer_numbers = true,
        },
    })
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

function M.barbar_keymaps()
    -- 关闭与清理 (Close & Pick)
    Map.nmap("<leader>pb", [[<Cmd>BufferPickDelete<CR>]], "Pick & Close")
    Map.nmap("<leader>cb", [[<Cmd>BufferClose<CR>]], "Close Current")
    Map.nmap("<leader>c[", [[<Cmd>BufferCloseBuffersLeft<CR>]], "Close All to the Left")
    Map.nmap("<leader>c]", [[<Cmd>BufferCloseBuffersRight<CR>]], "Close All to the Right")
    -- 切换与移动 (Switch & Move)
    -- 注意：Lua 的 [[ ]] 字符串中，单个反斜杠不需要额外转义
    Map.nmap("\\[", "<Cmd>BufferPrevious<CR>", "Previous")
    Map.nmap("\\]", "<Cmd>BufferNext<CR>", "Next")
    Map.nmap("\\{", "<Cmd>BufferMovePrevious<CR>", "Move Previous")
    Map.nmap("\\}", "<Cmd>BufferMoveNext<CR>", "Move Next")
    -- 快速跳转 (Quick Jump to Number)
    Map.nmap("<leader>1", [[<Cmd>BufferGoto 1<CR>]], "Go to Buffer 1")
    Map.nmap("<leader>2", [[<Cmd>BufferGoto 2<CR>]], "Go to Buffer 2")
    Map.nmap("<leader>3", [[<Cmd>BufferGoto 3<CR>]], "Go to Buffer 3")
    Map.nmap("<leader>4", [[<Cmd>BufferGoto 4<CR>]], "Go to Buffer 4")
    Map.nmap("<leader>5", [[<Cmd>BufferGoto 5<CR>]], "Go to Buffer 5")
    Map.nmap("<leader>6", [[<Cmd>BufferGoto 6<CR>]], "Go to Buffer 6")
    Map.nmap("<leader>7", [[<Cmd>BufferGoto 7<CR>]], "Go to Buffer 7")
    Map.nmap("<leader>8", [[<Cmd>BufferGoto 8<CR>]], "Go to Buffer 8")
    Map.nmap("<leader>9", [[<Cmd>BufferGoto 9<CR>]], "Go to Buffer 9")
    Map.nmap("<leader>0", [[<Cmd>BufferLast<CR>]], "Go to Last Buffer")
end

return M
