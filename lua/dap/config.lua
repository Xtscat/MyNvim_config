-- dap/config.lua

local M = {}

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

return M
