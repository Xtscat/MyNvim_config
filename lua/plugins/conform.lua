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
                cpp = { "clang_format" },
                cuda = { "clang_format" },
                javascript = { 'prettier' },
                typescript = { 'prettier' },
                html = { 'prettier' },
                css = { 'prettier' },
                markdown = { 'prettier' }
            },
            notify_on_error = true,
            formatters = {
                clang_format = {
                    -- args = { "--style={BasedOnStyle: google, IndentWidth: 2, ColumnLimit: 120}" }
                    args = { "--style={BasedOnStyle: google, IndentWidth: 4, ColumnLimit: 120, IndentAccessModifiers: false, AccessModifierOffset: -2, PointerAlignment: Middle}" }
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
