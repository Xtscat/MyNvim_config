-- configs/dap.lua

local M = {}
local Map = require("utils.map").with_prefix("DAP")
local last_launch = {
    program = nil,
    args = {},
}

local function input_program()
    local default_program = last_launch.program or (vim.fn.getcwd() .. "/")
    local program = vim.fn.input("Path to executable: ", default_program, "file")
    if program == nil or program == "" then
        return nil
    end
    last_launch.program = program
    return program
end

local function input_args()
    local default_args = table.concat(last_launch.args or {}, " ")
    local raw = vim.fn.input("Program args: ", default_args)
    if raw == nil or raw == "" then
        last_launch.args = {}
        return {}
    end
    local args = vim.split(raw, "%s+", { trimempty = true })
    last_launch.args = args
    return args
end

function M.mason_nvim_dap_config()
    require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb" },
        handlers = {},
    })
end

function M.dapview_config()
    require("dap-view").setup({
        auto_toggle = false,
    })
end

function M.dap_config()
    local dap = require("dap")

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticSignHint", linehl = "Visual", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "×", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })

    dap.configurations.c = {
        {
            name = "Launch file (input args)",
            type = "codelldb",
            request = "launch",
            program = function()
                return input_program()
            end,
            args = function()
                return input_args()
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
        {
            name = "Launch file (reuse last args)",
            type = "codelldb",
            request = "launch",
            program = function()
                return last_launch.program or input_program()
            end,
            args = function()
                return last_launch.args or {}
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }
    dap.configurations.cpp = dap.configurations.c

    local dapview = require("dap-view")
    dap.listeners.after.event_initialized["dap_view_open"] = function()
        dapview.open()
    end
    dap.listeners.before.event_terminated["dap_view_close"] = function()
        dapview.close()
    end
    dap.listeners.before.event_exited["dap_view_close"] = function()
        dapview.close()
    end
end

function M.dap_keymaps()
    local dap = require("dap")

    Map.nmap("<F5>", function()
        require("dap-view").open()
        dap.continue()
    end, "Start/Continue debug + open view")

    Map.nmap("<F6>", function()
        dap.terminate()
        require("dap-view").close()
    end, "Terminate debug + close view")

    Map.nmap("<leader>b", function()
        dap.toggle_breakpoint()
    end, "Toggle breakpoint")

    Map.nmap("<F9>", function()
        dap.step_into()
    end, "Step into")

    Map.nmap("<F10>", function()
        dap.step_over()
    end, "Step over")
end

return M
