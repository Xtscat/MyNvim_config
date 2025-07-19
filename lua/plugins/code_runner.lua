return {
    -- {
    --     "CRAG666/code_runner.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         require("code_runner").setup {
    --             vim.keymap.set('n', '<leader>rc', '<cmd>RunCode<cr>', { noremap = true, silent = false }, { desc = "[R]un[C]ode" }),
    --             mode = "term",
    --             filetype = {
    --                 c = {
    --                     "cd $dir &&",
    --                     "gcc $fileName -o",
    --                     "/tmp/$fileNameWithoutExt &&",
    --                     "/tmp/$fileNameWithoutExt &&",
    --                     "rm /tmp/$fileNameWithoutExt",
    --                 },
    --                 cpp = {
    --                     "cd $dir &&",
    --                     "g++ $fileName",
    --                     "-o /tmp/$fileNameWithoutExt &&",
    --                     "/tmp/$fileNameWithoutExt",
    --                 },
    --                 python = "python3 -u '$dir/$fileName'",
    --                 bash = "bash '$dir/$fileName'"
    --             }
    --         }
    --     end
    -- }
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
