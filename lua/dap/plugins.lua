-- dap/plugins.lua

return {
    { "nvim-neotest/nvim-nio" },
    { "rcarriga/nvim-dap-ui" },
    {
        "mfussenegger/nvim-dap",
        config = function()
            require("dap/config").nvim_dap_config()
            require("dap/keymaps").nvim_dap_keymaps()
        end
    }
}
