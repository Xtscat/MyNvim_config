-- return {
--     "stevearc/conform.nvim",
--     event = "VeryLazy",
--     config = function()
--         require("conform").setup({
--             -- Map of filetype to formatters
--             formatters_by_ft = {
--                 lua = { "stylua" },
--                 python = { "yapf", "isort" },
--                 -- python = { "yapf" },
--                 c = { "clang_format" },
--                 cpp = { "clang_format" }
--             },
--             notify_on_error = true,
--             vim.api.nvim_create_user_command("Format", function(args)
--                 local range = nil
--                 if args.count ~= -1 then
--                     local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
--                     range = {
--                         start = { args.line1, 0 },
--                         ["end"] = { args.line2, end_line:len() },
--                     }
--                 end
--                 require("conform").format({ async = true, lsp_fallback = true, range = range })
--             end, { range = true }),
--             vim.keymap.set("n", "<C-l>", "<cmd>Format<CR>", { noremap = true, silent = true })
--         })
--
--         require("conform.formatters.clang_format").args = { "--style={BasedOnStyle: google, IndentWidth: 4}" }
--         -- require("conform.formatters.yapf").args = { "-filename","$FILENAME" }
--         -- require("conform").formatters.yapf={
--         --
--         -- }
--     end
-- }
return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
        require("conform").setup({
            -- map of filetype to formatters
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "yapf", "isort" },
                -- python = { "yapf" },
                c = { "clang_format" },
                cpp = { "clang_format" }
            },
            notify_on_error = true,
            formatters = {
                clang_format = {
                    args = { "--style={BasedOnStyle: google, IndentWidth: 4}" }
                }
            },
            vim.api.nvim_create_user_command("Format", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_fallback = true, range = range })
            end, { range = true }),
            vim.keymap.set("n", "<c-l>", "<cmd>Format<cr>", { noremap = true, silent = true })
        })
    end
}
