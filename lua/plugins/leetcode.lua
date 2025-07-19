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
        lang = "python3",
        cn = {
            enabled = true,
            translator = true,
            translate_problems = true,
        },
    },
}
