return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
        "nvim-telescope/telescope.nvim",
        -- "ibhagwan/fzf-lua",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        arg = 'leetcode.nvim',
        lang = "cpp",
        cn = {
            enabled = true,
            translator = true,
            translate_problems = true,
        },
        editor = {
            reset_previous_code = true, ---@type boolean
            fold_imports = false, ---@type boolean
        },
        theme = {
            ["alt"] = {
                bg = "#FAFAFA",
                fg = "#000000"
            },
            ["normal"] = {
                fg = "#000000"
            }
        }
    },
}
