-- configs/base.lua

local M = {}
local Map = require("utils.map").with_prefix("Base")

-- function M.treesitter_config()
--     local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
--     parser_config.ipynb = {
--         install_info = {
--             -- 指向 ipynb.nvim 插件安装目录下的 tree-sitter-ipynb 文件夹
--             -- 注意：如果你修改了 lazy 的安装路径，这里也需要相应修改
--             url = vim.fn.stdpath("data") .. "/lazy/ipynb.nvim/tree-sitter-ipynb",
--             files = { "src/parser.c", "src/scanner.c" },
--             branch = "main",
--             generate_requires_npm = false,
--             requires_generate_from_grammar = false,
--         },
--         filetype = "ipynb",
--     }
--     require 'nvim-treesitter.configs'.setup {
--         ensure_installed = { "c", "cpp", "python", "bash", "html", "lua", "markdown", "markdown_inline" },
--         auto_install = true,
--         highlight = {
--             enable = true,
--             additional_vim_regex_highlighting = true,
--         },
--     }
-- end

function M.treesitter_config()
    require("tree-sitter-manager").setup({
        ensure_installed = { "c", "cpp", "python", "bash", "html", "lua", "markdown", "markdown_inline" },
        highlight = true
    })
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
        picker = {
            enabled = true,
            -- 布局预设：左右分栏，右侧预览
            layout = {
                preset = "ivy", -- 你也可以用 "minimal" / "vertical" 等
                width = 0.9,
                height = 0.85,
                preview = "right",
            },
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

    -- :Vsp / :Hsp —— 从 buffer 或同目录文件选一个 split 打开
    -- 补全：已打开 buffer 名 + 当前目录文件名
    local function complete(arg_lead)
        local seen, items = {}, {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
            if name ~= "" and not seen[name] and vim.startswith(name, arg_lead) then
                seen[name] = true
                items[#items + 1] = name
            end
        end
        local dir = vim.fn.expand("%:p:h")
        if dir ~= "" then
            for _, f in ipairs(vim.fn.readdir(dir)) do
                if not seen[f] and vim.startswith(f, arg_lead) then
                    seen[f] = true
                    items[#items + 1] = f
                end
            end
        end
        return items
    end

    local function make_split_cmd(name, split_cmd)
        vim.api.nvim_create_user_command(name, function(opts)
            local arg = vim.trim(opts.args)
            if arg == "" then
                Snacks.picker.buffers({
                    actions = {
                        confirm = function(picker, item)
                            picker:close()
                            vim.cmd(split_cmd .. item.bufnr)
                        end,
                    },
                })
            else
                local ok, _ = pcall(vim.cmd, split_cmd .. arg)
                if not ok then
                    local file_cmd = split_cmd == "vert sb " and "vsplit " or "split "
                    vim.cmd(file_cmd .. arg)
                end
            end
        end, { nargs = "?", complete = complete })
    end

    make_split_cmd("Vsp", "vert sb ")
    make_split_cmd("Hsp", "sb ")

    vim.cmd([[
        cnoreabbrev <expr> vsp getcmdtype() == ':' && getcmdline() == 'vsp' ? 'Vsp' : 'vsp'
        cnoreabbrev <expr> hsp getcmdtype() == ':' && getcmdline() == 'hsp' ? 'Hsp' : 'hsp'
    ]])
end

return M
