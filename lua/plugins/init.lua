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
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = with_config_and_keys("configs.base", "snacks_config", "snacks_keymaps")
    },
}

local edit = {
    -- {
    --     -- 括号 / 成对符号
    --     "kylechui/nvim-surround",
    --     version = "*",
    --     event = "VeryLazy",
    --     config = with_config_and_keys("configs.edit", nil, "nvim_surround_keymaps"),
    -- },
    { "numToStr/Comment.nvim",      config = with_config_and_keys("configs.edit", "comment_config", nil), },
    { "windwp/nvim-autopairs",      event = "InsertEnter",                                                             opts = {} },
    -- 更多的 'a'/'i' 对象
    { "echasnovski/mini.ai",        event = "VeryLazy",                                                                opts = {} },
    -- tabout
    { "kawre/neotab.nvim",          config = with_config_and_keys("configs.edit", "neotab_config", nil) },
    -- 在 'true/false', 'on/off', 'yes/no', 'enabled/disable' 之间切换
    { "nguyenvukhang/nvim-toggler", config = with_config_and_keys("configs.edit", "nvim_toggler_config", nil) },
    -- 高亮搜索增强
    { "kevinhwang91/nvim-hlslens",  config = with_config_and_keys("configs.edit", "hlslens_config", "hlslens_keymaps") },
    { "Pocco81/auto-save.nvim",     config = with_config_and_keys("configs.edit", "autosave_config", nil) },
    { "ethanholz/nvim-lastplace",   opts = {} },
}

local ui = {
    -->>> theme
    {
        "JManch/sunset.nvim",
        lazy = false,
        priority = 1000,
        config = with_config_and_keys("configs.ui", "sunset_config", nil)
    },
    { "sainnhe/edge",                        lazy = false },
    { "navarasu/onedark.nvim",               lazy = false },
    { "folke/tokyonight.nvim",               lazy = false },
    {
        "rmehri01/onenord.nvim",
        lazy = false,
        config = with_config_and_keys("configs.ui", "onenord_config", nil)
    },
    -->>> widgets
    -- 下方状态栏
    { "nvim-lualine/lualine.nvim",           config = with_config_and_keys("configs.ui", "lualine_config", nil) },
    -- 上方winbar
    { "Bekaboo/dropbar.nvim",                config = with_config_and_keys("configs.ui", "dropbar_config", nil) },
    -- 标签页增强
    { "romgrk/barbar.nvim",                  config = with_config_and_keys("configs.ui", "barbar_config", "barbar_keymaps") },
    -- 右侧滚动条
    -- { "dstein64/nvim-scrollview",            config = with_config_and_keys("configs.ui", "nvim_scrollview_config", nil) },
    { "petertriho/nvim-scrollbar",           config = with_config_and_keys("configs.ui", "nvim_scrollbar_config", nil),     opts = {} },
    -- 缩进线
    { "lukas-reineke/indent-blankline.nvim", config = with_config_and_keys("configs.ui", "indent_blankline_config", nil) },
    -- 高亮当前行 / 列
    { "yamatsum/nvim-cursorline",            config = with_config_and_keys("configs.ui", "nvim_cursorline_config", nil) },
    { "lewis6991/gitsigns.nvim",             config = with_config_and_keys("configs.ui", "gitsigns_config", nil) },
}

local lsp = {
    -->>> LSP
    -- lsp 管理
    { "neovim/nvim-lspconfig",            event = { "BufReadPost", "BufNewFile" },                          config = with_config_and_keys("configs.lsp", "lsp_config", nil) },
    { "williamboman/mason.nvim",          config = with_config_and_keys("configs.lsp", "mason_config", nil) },
    { "williamboman/mason-lspconfig.nvim" },
    {
        "folke/trouble.nvim",
        lazy = false,
        cmd = "Trouble",
        config = with_config_and_keys("configs.lsp", "trouble_config", "trouble_keymaps")
    },
    -- lsp 进度条
    { "j-hui/fidget.nvim",           config = with_config_and_keys("configs.lsp", "fidget_config", nil) },
    -->>> CMP
    { "rafamadriz/friendly-snippets" },
    { "L3MON4D3/LuaSnip",            version = "v2.*",                                                  build = "make install_jsregexp" },
    -- 补全
    { "saghen/blink.cmp",            version = "1.*",                                                   config = with_config_and_keys("configs.lsp", "blink_config", nil) },
    -->>> Formatter
    { "stevearc/conform.nvim",       event = "VeryLazy",                                                config = with_config_and_keys("configs.lsp", "conform_config", "conform_keymaps") }
}

local cmake = {
    {
        "Civitasv/cmake-tools.nvim",
        lazy = false,
        cmd = {
            "CMakeGenerate",
            "CMakeBuild",
            "CMakeRun",
            "CMakeDebug",
            "CMakeCloseExecutor",
            "CMakeCloseRunner",
            "CMakeSelectBuildType",
            "CMakeSelectBuildTarget",
            "CMakeSelectLaunchTarget",
            "CMakeSelectConfigurePreset",
            "CMakeSelectBuildPreset",
            "CMakeSelectLaunchPreset",
        },
        config = with_config_and_keys("configs.cmake", "cmake_tools_config", "cmake_tools_keymaps")
    },
}

local dap = {
    {
        "mfussenegger/nvim-dap",
        config = with_config_and_keys("configs.dap", "dap_config", "dap_keymaps")
    },
    {
        "igorlfs/nvim-dap-view",
        version = "1.*",
        dependencies = { "mfussenegger/nvim-dap" },
        cmd = { "DapViewOpen", "DapViewClose", "DapViewToggle", "DapViewWatch", "DapViewJump", "DapViewShow", "DapViewNavigate" },
        config = with_config_and_keys("configs.dap", "dapview_config", nil)
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
        config = with_config_and_keys("configs.dap", "mason_nvim_dap_config", nil)
    },
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
        "MarcusGrass/nvim_winpick",
        branch = "x86_64-unknown-linux-gnu-latest",
        lazy = false,
        config = with_config_and_keys("configs.window", "winpick_config", "winpick_keymap")
    },
}

local navigation = {
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


local filetype = {
    markdown = {
        -- markview.nvim maybe better
        {
            "OXY2DEV/markview.nvim",
            lazy = false,
            config = with_config_and_keys("configs.md", "markview_config", nil)
        },
        -- {
        --     "MeanderingProgrammer/render-markdown.nvim",
        --     config = with_config_and_keys("configs.md", "render_markdown_config", nil)
        -- },
        {
            "yutanagano/smark.nvim",
            config = with_config_and_keys("configs.md", "smark_config", nil)
        },
    },

    latex = {
        { "lervag/vimtex", ft = { "tex", "plaintex", "bib" }, config = with_config_and_keys("configs.tex", "tex_config", nil) }
    },

    ipynb = {
        {
            "ajbucci/ipynb.nvim",
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
                "folke/snacks.nvim"
            },
            config = with_config_and_keys("configs.ipynb", "ipynb_config", nil)
        }
    },

    hex = {
        {
            "Punity122333/hexinspector.nvim",
            cmd = { "HexEdit", "HexInspect" },
            lazy = false,
            config = with_config_and_keys("configs.hex", "hex_config", "hex_keymaps")
        },
    }
}

return join(
    base,
    edit,
    ui,
    lsp,
    cmake,
    dap,
    window,
    navigation,
    filetype.markdown,
    filetype.latex,
    filetype.ipynb,
    filetype.hex
)
