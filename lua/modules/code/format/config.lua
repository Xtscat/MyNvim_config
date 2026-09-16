-- modules/code/format/config.lua
--
-- conform.nvim: format the current buffer with the right tool per filetype.

local M = {}

function M.conform()
    require("conform").setup({
        -- filetype -> formatters to run, in order (e.g. python: yapf then isort)
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "yapf", "isort" },
            c = { "clang_format" },
            cpp = { "clang_format" },
            cuda = { "clang_format" },
            javascript = { "prettier" },
            json = { "biome" },
            typescript = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            markdown = { "prettier" },
        },
        notify_on_error = true,
        -- Give clang-format an inline style instead of relying on a
        -- .clang-format file on disk.
        formatters = {
            clang_format = {
                args = {
                    [[--style={
                        AccessModifierOffset: -2,
                        AlignConsecutiveAssignments: true,
                        AlignConsecutiveDeclarations: true,
                        AlignTrailingComments: true,
                        AllowAllArgumentsOnNextLine: true,
                        AllowAllConstructorInitializersOnNextLine: true,
                        AllowAllParametersOfDeclarationOnNextLine: false,
                        AllowShortBlocksOnASingleLine: Empty,
                        AllowShortFunctionsOnASingleLine: Empty,
                        BasedOnStyle: google,
                        BinPackArguments: false,
                        BinPackParameters: false,
                        ColumnLimit: 160,
                        IndentWidth: 2,
                        IndentAccessModifiers: false,
                        PenaltyBreakBeforeFirstCallParameter: 0,
                        PointerAlignment: Left,
                    }]],
                },
            },
        },
    })

    -- :Format formats the whole buffer; :'<,'>Format formats a range.
    -- `range = true` lets the command receive line1/line2/count.
    vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
            -- build an explicit start/end range from the visual selection
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
            }
        end
        require("conform").format({ async = true, lsp_fallback = true, range = range })
    end, { range = true })
end

return M
