-- dap/keymaps.lua

local M = {}

local nmap = function(keys, func, desc)
    if desc then
        desc = 'UI: ' .. desc
    end
    vim.keymap.set('n', keys, func, { desc = desc })
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

    nmap('<F5>', function()
        dap.continue()
        edgy.close()
    end, 'DAP: Close Edgy & Continue')
    nmap('<F6>', function()
        dap.terminate()
        edgy.open('left')
    end, 'DAP: Terminate & Open Edgy Left')
    nmap('<F10>', dap.step_over, 'DAP: Step Over')
    nmap('<F11>', dap.step_into, 'DAP: Step Into')
    nmap('<F12>', dap.step_out, 'DAP: Step Out')
    nmap('<Leader>b', dap.toggle_breakpoint, 'DAP: Toggle Breakpoint')
    nmap('<Leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, 'DAP: Set Conditional Breakpoint')
    nmap('<Leader>lp', function()
        dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, 'DAP: Set Log Point')
    nmap('<Leader>dr', dap.repl.open, 'DAP: Open REPL')
    nmap('<Leader>dl', dap.run_last, 'DAP: Run Last')
end

return M
