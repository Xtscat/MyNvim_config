return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = false, -- 设置为"*"始终使用最新版本，false表示使用最新代码
    opts = {
        -- 深度思考AI配置
        provider = "gemini",
        gemini = {
            model = 'gemini-exp-1206',
            temperature = 0,
            max_tokens = 8192
        },
        vendors = {
            deepseek = {
                __inherited_from = "openai",                           -- 继承OpenAI的配置
                api_key_name = "Deepseek_API_KEY",                     -- 环境变量中的API密钥名称
                endpoint = "https://ark.cn-beijing.volces.com/api/v3", -- 深度思考API端点
                model = "ep-20250223181020-p2zgj",                     -- 使用的模型名称
                disable_tools = true,                                  -- 禁用工具调用
                max_tokens = 8192,                                     -- 最大token数
                temperature = 0,
            },
        },
        behaviour = {
            auto_suggestions = false,                 -- 自动建议（实验性功能）
            auto_set_highlight_group = true,          -- 自动设置高亮组
            auto_set_keymaps = true,                  -- 自动设置快捷键映射
            auto_apply_diff_after_generation = false, -- 生成后自动应用差异
            support_paste_from_clipboard = false,     -- 支持从剪贴板粘贴
            minimize_diff = true,                     -- 应用代码块时删除未修改行
            enable_token_counting = true,             -- 启用token计数
            enable_cursor_planning_mode = false,      -- 光标规划模式
        },
        mappings = {
            --- @class AvanteConflictMappings
            diff = {
                ours = "co",       -- 接受当前更改
                theirs = "ct",     -- 接受传入更改
                all_theirs = "ca", -- 接受所有传入更改
                both = "cb",       -- 接受双方更改
                cursor = "cc",     -- 光标处应用更改
                next = "]x",       -- 下一个冲突
                prev = "[x",       -- 上一个冲突
            },
            suggestion = {
                accept = "<M-l>",  -- 接受建议
                next = "<M-]>",    -- 下个建议
                prev = "<M-[>",    -- 上个建议
                dismiss = "<C-]>", -- 忽略建议
            },
            jump = {
                next = "]]", -- 跳转下一个代码块
                prev = "[[", -- 跳转上一个代码块
            },
            submit = {
                normal = "<CR>",  -- 普通模式提交
                insert = "<C-s>", -- 插入模式提交
            },
            sidebar = {
                apply_all = "A",                    -- 应用所有更改
                apply_cursor = "a",                 -- 应用光标处更改
                switch_windows = "<Tab>",           -- 切换窗口焦点
                reverse_switch_windows = "<S-Tab>", -- 反向切换窗口
            },
        },
        hints = { enabled = true }, -- 启用操作提示
        windows = {
            position = "right",     -- 侧边栏位置：right/left/top/bottom
            wrap = true,            -- 自动换行
            width = 30,             -- 侧边栏宽度百分比
            sidebar_header = {
                enabled = true,     -- 显示侧边栏标题
                align = "center",   -- 标题对齐方式
                rounded = true,     -- 圆角边框
            },
            input = {
                prefix = "> ", -- 输入框前缀
                height = 8,    -- 输入框高度（垂直布局时）
            },
            edit = {
                border = "rounded",  -- 编辑窗口边框样式
                start_insert = true, -- 打开即进入插入模式
            },
            ask = {
                floating = false,        -- 使用浮动窗口提问
                start_insert = true,     -- 打开即进入插入模式
                border = "rounded",      -- 边框样式
                focus_on_apply = "ours", -- 应用后聚焦当前/传入差异
            },
        },
        highlights = {
            diff = {
                current = "DiffText", -- 当前差异高亮
                incoming = "DiffAdd", -- 传入差异高亮
            },
        },
        diff = {
            autojump = true,           -- 自动跳转到第一个差异
            list_opener = "copen",     -- 打开差异列表的命令
            override_timeoutlen = 500, -- 临时修改timeoutlen设置
        },
        suggestion = {
            debounce = 600, -- 去抖动延迟(ms)
            throttle = 600, -- 节流间隔(ms)
        },
    },
    build = "make", -- 编译命令
    dependencies = {
        -- 核心依赖
        "nvim-treesitter/nvim-treesitter", -- 语法解析
        "stevearc/dressing.nvim",          -- UI增强
        "nvim-lua/plenary.nvim",           -- 常用函数库
        "MunifTanjim/nui.nvim",            -- UI组件库

        -- 可选依赖
        "echasnovski/mini.pick",         -- 文件选择器(mini.pick)
        "nvim-telescope/telescope.nvim", -- 文件选择器(telescope)
        "hrsh7th/nvim-cmp",              -- 自动补全
        "ibhagwan/fzf-lua",              -- 文件选择器(fzf)
        "nvim-tree/nvim-web-devicons",   -- 文件图标
        "zbirenbaum/copilot.lua",        -- Copilot集成

        -- 图片粘贴支持
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false, -- 不以base64嵌入图片
                    prompt_for_file_name = false,  -- 不提示文件名
                    drag_and_drop = {
                        insert_mode = true,        -- 插入模式拖放支持
                    },
                    use_absolute_path = true,      -- 使用绝对路径
                },
            },
        },

        -- Markdown渲染
        {
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" }, -- 支持的文件类型
            },
            ft = { "markdown", "Avante" },             -- 按需加载
        },
    },
}
