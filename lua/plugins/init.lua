-- plugins/init.lua
local function with_config_and_keys(mod, cfg_fn, keys_fn)
    return function()
        local m = require(mod)
        if cfg_fn and m[cfg_fn] then
            m[cfg_fn]()
        end
        if keys_fn and m[keys_fn] then
            m[keys_fn]()
        end
    end
end

local function join(...)
    local out = {}
    for _, t in ipairs({ ... }) do
        vim.list_extend(out, t)
    end
    return out
end

local base = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "folke/which-key.nvim",        opts = {} },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "VeryLazy",
        config = with_config_and_keys("configs.base", "treesitter_config", nil)
    },
}

local edit = {
    {
        "numToStr/Comment.nvim",
        config = with_config_and_keys("configs.edit", "comment_config", nil),
    },
    {
        -- 括号 / 成对符号
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = with_config_and_keys("configs.edit", nil, "nvim_surround_keymaps"),
    },
    { "windwp/nvim-autopairs",    event = "InsertEnter", opts = {} },
    {
        -- 更多的 'a'/'i' 对象
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = {},
    },
    {
        -- tabout
        "kawre/neotab.nvim",
        config = with_config_and_keys("configs.edit", "neotab_config", nil)
    },
    {
        -- 在 'true/false', 'on/off', 'yes/no', 'enabled/disable' 之间切换
        "nguyenvukhang/nvim-toggler",
        config = with_config_and_keys("configs.edit", "nvim_toggler_config", nil)
    },
    {
        -- 高亮搜索增强
        "kevinhwang91/nvim-hlslens",
        config = with_config_and_keys("configs.edit", "hlslens_config", "hlslens_keymaps")
    },
    {
        "Pocco81/auto-save.nvim",
        config = with_config_and_keys("configs.edit", "autosave_config", nil)
    },
    { "ethanholz/nvim-lastplace", opts = {} },

}

local ui = {
    -->>> theme
    { "sainnhe/edge",          lazy = false },
    { "navarasu/onedark.nvim", lazy = false },
    {
        "JManch/sunset.nvim",
        lazy = false,
        priority = 1000,
        config = with_config_and_keys("configs.ui", "sunset_config", nil)
    },
    -->>> widgets
    {
        -- 上方状态栏
        "nvim-lualine/lualine.nvim",
        config = with_config_and_keys("configs.ui", "lualine_config", nil)
    },
    {
        -- 标签页增强
        "romgrk/barbar.nvim",
        config = with_config_and_keys("configs.ui", "barbar_config", "barbar_keymaps")
    },
    {
        -- 右侧滚动条
        "dstein64/nvim-scrollview",
        config = with_config_and_keys("configs.ui", "nvim_scrollview_config", nil)
    },
    {
        -- 缩进线
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = with_config_and_keys("configs.ui", "indent_blankline_config", nil)
    },
    {
        -- 高亮当前行 / 列
        "yamatsum/nvim-cursorline",
        config = with_config_and_keys("configs.ui", "nvim_cursorline_config", nil)
    },
    { "lewis6991/gitsigns.nvim", opts = {} },

}

local lsp = {
    -->>> LSP
    {
        -- lsp 管理
        "williamboman/mason.nvim",
        config = with_config_and_keys("configs.lsp", "mason_config", nil)
    },
    { "williamboman/mason-lspconfig.nvim" },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        config = with_config_and_keys("configs.lsp", "lsp_config", nil)
    },
    {
        -- lsp 美化
        "nvimdev/lspsaga.nvim",
        config = with_config_and_keys("configs.lsp", "lspsaga_config", "lsp_keymaps")
    },
    {
        -- lsp 进度条
        "j-hui/fidget.nvim",
        config = with_config_and_keys("configs.lsp", "fidget_config", nil)
    },
    { "folke/trouble.nvim",               cmd = "Trouble",  opts = {}, },
    -->>> CMP
    { "L3MON4D3/LuaSnip",                 version = "v2.*", build = "make install_jsregexp" },
    { "rafamadriz/friendly-snippets" },
    {
        -- 补全
        "saghen/blink.cmp",
        version = "1.*",
        config = with_config_and_keys("configs.lsp", "blink_config", nil)
    },
    -->>> Formatter
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        config = with_config_and_keys("configs.lsp", "conform_config", "conform_keymaps")
    },

}

local dap = {
    {
        "mfussenegger/nvim-dap",
        config = with_config_and_keys("configs.dap", "nvim_dap_config", "nvim_dap_keymaps")
    },
    { "rcarriga/nvim-dap-ui" },
    { "nvim-neotest/nvim-nio" },
}

local window = {
    {
        -- 窗口布局管理
        "folke/edgy.nvim",
        init = function()
            vim.opt.splitkeep = "screen"
        end,
        config = with_config_and_keys("configs.window", "edgy_config", nil)
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = with_config_and_keys("configs.window", "toggleterm_config", "toggleterm_keymaps")
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = with_config_and_keys("configs.window", "snacks_config", nil)
    },
    {
        "MarcusGrass/nvim_winpick",
        branch = "x86_64-unknown-linux-gnu-latest",
        lazy = false,
        config = with_config_and_keys("configs.window", "winpick_config", "winpick_keymap")
    },
}

local navigation = {
    -- for telescope
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-lua/plenary.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        event = "VeryLazy",
        config = with_config_and_keys("configs.navigation", "telescope_config", "telescope_keymaps")
    },

    -->>> neo-tree
    { "MunifTanjim/nui.nvim" },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        config = with_config_and_keys("configs.navigation", "neotree_config", "neotree_keymaps")
    },

    -->>> outline
    {
        "hedyhli/outline.nvim",
        config = with_config_and_keys("configs.navigation", "outline_config", "outline_keymaps")
    },
}

local ai = {
    {
        "NickvanDyke/opencode.nvim",
        config = with_config_and_keys("configs.ai", "opencode_config", "opencode_keymaps")
    },

}

local md = {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        config = with_config_and_keys("configs.md", "render_markdown_config", nil)
    },
    -- {
    --     "DingDean/smark.nvim",
    --     config = with_config_and_keys("configs.md", "smark_config", nil)
    -- },
}

return join(base, edit, ui, lsp, dap, window, navigation, ai, md)
