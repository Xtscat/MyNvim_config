return {
    { -- This plugin
        "Zeioth/compiler.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
        vim.api.nvim_set_keymap('n', '<leader>rc', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true }),
        opts = {},
    },
    { -- The task runner we use
        "stevearc/overseer.nvim",
        commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 15,
                max_height = 20,
                default_detail = 1
            },
        },
    },
}
