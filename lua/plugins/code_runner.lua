return {
    {
        "CRAG666/code_runner.nvim",
        event = "VeryLazy",
        config = function()
            require("code_runner").setup {
                vim.keymap.set('n', '<leader>rc', '<cmd>RunCode<cr>', { noremap = true, silent = false }, { desc = "[R]un[C]ode" }),
                mode = "term",
                filetype = {
                    c = {
                        "cd $dir &&",
                        "gcc $fileName -o",
                        "/tmp/$fileNameWithoutExt &&",
                        "/tmp/$fileNameWithoutExt &&",
                        "rm /tmp/$fileNameWithoutExt",
                    },
                    cpp = {
                        "cd $dir &&",
                        "g++ $fileName",
                        "-o /tmp/$fileNameWithoutExt &&",
                        "/tmp/$fileNameWithoutExt",
                    },
                    python = "python3 -u '$dir/$fileName'",
                    bash = "bash '$dir/$fileName'"
                }
            }
        end
    }
}
