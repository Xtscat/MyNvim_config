-- configs/dap.lua

local M = {}
local Map = require("utils.map").with_prefix("DAP")

function M.nvim_dap_config()
    local dap = require("dap")

    -- 自定义 DAP 符号（断点/停止等）
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
    vim.fn.sign_define("DapBreakpointCondition",
        { text = "", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DapBreakpointRejected",
        { text = "", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" })

    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
            command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
            args = { "--port", "${port}" },
        }
    }

    local function pick_program()
        local cwd = vim.fn.getcwd()
        local build = cwd .. "/build"
        local candidates = vim.fn.globpath(build, "*", false, true)
        table.sort(candidates, function(a, b)
            return vim.fn.getftime(a) > vim.fn.getftime(b)
        end)
        for _, path in ipairs(candidates) do
            if vim.fn.isdirectory(path) == 0 and vim.fn.executable(path) == 1 then
                return path
            end
        end
        return vim.fn.input('Path to executable: ', build .. '/', 'file')
    end

    -- 为 C/C++ 配置调试启动项
    dap.configurations.cpp = {
        {
            name = "Launch build target",
            type = "codelldb", -- 这个 'type' 必须与上面的 dap.adapters.codelldb 匹配
            request = "launch",
            program = pick_program,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
        },
    }
    -- 为 C 语言也设置相同的配置
    dap.configurations.c = dap.configurations.cpp
end

function M.dap_view_config()
    local ok_view, dap_view = pcall(require, "dap-view")
    if not ok_view then
        return
    end

    dap_view.setup({
        winbar = {
            show = true,
            sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
            default_section = "watches",
            base_sections = {
                breakpoints = {
                    keymap = "B",
                    label = "Breakpoints [B]",
                    short_label = " [B]",
                },
                scopes = {
                    keymap = "S",
                    label = "Scopes [S]",
                    short_label = "󰂥 [S]",
                },
                exceptions = {
                    keymap = "E",
                    label = "Exceptions [E]",
                    short_label = "󰢃 [E]",
                },
                watches = {
                    keymap = "W",
                    label = "Watches [W]",
                    short_label = "󰛐 [W]",
                },
                threads = {
                    keymap = "T",
                    label = "Threads [T]",
                    short_label = "󱉯 [T]",
                },
                repl = {
                    keymap = "R",
                    label = "REPL [R]",
                    short_label = "󰯃 [R]",
                },
                sessions = {
                    keymap = "K",
                    label = "Sessions [K]",
                    short_label = " [K]",
                },
                console = {
                    keymap = "C",
                    label = "Console [C]",
                    short_label = "󰆍 [C]",
                },
            },
            custom_sections = {},
            controls = {
                enabled = true,
                position = "right",
                buttons = {
                    "play",
                    "step_into",
                    "step_over",
                    "step_out",
                    "step_back",
                    "run_last",
                    "terminate",
                    "disconnect",
                },
                custom_buttons = {},
            },
        },
        windows = {
            height = 0.25,
            position = "below",
            terminal = {
                width = 0.5,
                position = "left",
                hide = {},
                start_hidden = true,
            },
        },
        icons = {
            disabled = "",
            disconnect = "",
            enabled = "",
            filter = "󰈲",
            negate = " ",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = "",
        },
        help = {
            border = nil,
        },
        render = {
            sort_variables = nil,
        },
        switchbuf = "usetab,uselast",
        auto_toggle = "keep_terminal",
        follow_tab = true,
    })
end

function M.nvim_dap_keymaps()
    -- F5: 关闭所有 edgy 窗口，然后启动/继续调试
    -- F6: 终止调试会话，并在 dap-ui 关闭后，重新打开 edgy 左侧窗口
    -- F9 单步进入, 进入函数内部执行函数每条语句
    -- F10 单步跳过, 完整地执行函数单不在函数中停留
    -- F11 单步调出, 单步进入之后执行函数后面所有内容, 跳出函数不在函数中停留

    -- 'leader b'  添加/移除断点
    -- 'leader B'  条件断点
    -- 'leader dv' 打开dapview窗口
    local dap = require('dap')

    Map.nmap('<F5>', function() dap.continue() end, 'Close Edgy & Continue')
    Map.nmap('<F6>', function() dap.terminate() end, 'Terminate & Open Edgy Left')
    Map.nmap('<F9>', dap.step_into, 'Step Into')
    Map.nmap('<F10>', dap.step_over, 'Step Over')
    Map.nmap('<F11>', dap.step_out, 'Step Out')
    Map.nmap('<Leader>dv', '<cmd>DapViewToggle<CR>', 'DapView Toggle')
    Map.nmap('<Leader>b', dap.toggle_breakpoint, 'Toggle Breakpoint')
    Map.nmap('<Leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        'Set Conditional Breakpoint')
end

return M
