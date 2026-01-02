local M = {}
local Map = require("utils.map").with_prefix("DAP")

function M.nvim_dap_config()
    local dap = require("dap")
    local dapui = require("dapui")
    local edgy = require("edgy")

    -- dap-ui 的基本设置
    dapui.setup()

    -- 设置监听器，在调试会话开始时打开 dap-ui，在结束时关闭
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    -- [核心修改] 手动配置 codelldb 调试适配器
    -- 我们直接指定 mason 安装的 codelldb 的路径
    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
            -- vim.fn.stdpath("data") 返回 Neovim 的数据目录
            -- mason 将工具安装在 'data/mason/bin/' 下
            command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
            args = { "--port", "${port}" },

            -- 以下对于 codelldb 不是必需的，但作为示例保留
            -- detached = false,
        }
    }

    -- 为 C/C++ 配置调试启动项
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "codelldb", -- 这个 'type' 必须与上面的 dap.adapters.codelldb 匹配
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
        },
    }
    -- 为 C 语言也设置相同的配置
    dap.configurations.c = dap.configurations.cpp
end

function M.nvim_dap_keymaps()
    -- F5: 关闭所有 edgy 窗口，然后启动/继续调试
    -- F6: 终止调试会话，并在 dap-ui 关闭后，重新打开 edgy 左侧窗口
    -- F10 单步跳过, 完整地执行函数单不在函数中停留
    -- F11 单步进入, 进入函数内部执行函数每条语句
    -- F12 单步调出, 单步进入之后执行函数后面所有内容, 跳出函数不在函数中停留

    -- `leader b`  添加/移除断点
    -- `leader B`  条件断点
    -- `leader lp` 日志点(不暂停程序执行单执行到日志点时输出内容)
    -- `leader dr` 打开REPL窗口(一个交互式控制台)
    -- `leader dl` 重新运行上一次调试会话
    -- `leader dh` 悬浮显示变量信息
    local dap = require('dap')
    local edgy = require('edgy')

    Map.nmap('<F5>', function()
        dap.continue()
        edgy.close()
    end, 'DAP: Close Edgy & Continue')
    Map.nmap('<F6>', function()
        dap.terminate()
        edgy.open('left')
    end, 'DAP: Terminate & Open Edgy Left')
    Map.nmap('<F10>', dap.step_over, 'DAP: Step Over')
    Map.nmap('<F11>', dap.step_into, 'DAP: Step Into')
    Map.nmap('<F12>', dap.step_out, 'DAP: Step Out')
    Map.nmap('<Leader>b', dap.toggle_breakpoint, 'DAP: Toggle Breakpoint')
    Map.nmap('<Leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, 'DAP: Set Conditional Breakpoint')
    Map.nmap('<Leader>lp', function()
        dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, 'DAP: Set Log Point')
    Map.nmap('<Leader>dr', dap.repl.open, 'DAP: Open REPL')
    Map.nmap('<Leader>dl', dap.run_last, 'DAP: Run Last')
end

return M
