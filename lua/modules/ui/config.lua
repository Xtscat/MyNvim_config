-- modules/ui/config.lua
--
-- Setup for the look-and-layout plugins: colorscheme, bars, scrollbar,
-- indent guides, cursorline, window layout (edgy) and terminal.

local M = {}

-- Day/night colorscheme switching. sunset calls day_callback/night_callback
-- based on sunrise/sunset at the given coordinates. The two callbacks are
-- public (M.theme_day / M.theme_night) so they can be flipped by hand:
--   :lua require("modules.ui.config").theme_day()
function M.sunset()
    require("sunset").setup({
        latitude = 34.26111,
        longitude = 108.94250,
        day_callback = M.theme_day,
        night_callback = M.theme_night,
    })
end

-- sainnhe/edge, light variant. `colors_name` is cleared first on purpose:
-- changing 'background' makes Neovim re-source the active colorscheme, so the
-- old theme would be re-applied once for nothing before the switch.
function M.theme_day()
    vim.g.colors_name = nil
    vim.opt.background = "light"
    vim.cmd.colorscheme("edge")
end

-- navarasu/onedark, the dark theme this config has always used. The `style`
-- option has to be written through setup(): it lives in vim.g.onedark_config, so
-- `require("onedark").style = "dark"` is a silent no-op, and onedark pins
-- itself to "light" for as long as that option says "light".
function M.theme_night()
    vim.g.colors_name = nil
    vim.opt.background = "dark"
    require("onedark").setup({ style = "dark" })
    vim.cmd.colorscheme("onedark")
end

-- Bottom statusline (global, because laststatus=3).
function M.lualine()
    -- small helper component: show the first attached LSP client's name
    local function lsp_name()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local client = clients and clients[1]
        return (client and client.name) or "No Active LSP"
    end

    require("lualine").setup({
        options = {
            globalstatus = true,
            component_separators = "",
            section_separators = "",
        },
        sections = {
            -- lualine_a/b/c = left side; lualine_x/y/z = right side
            lualine_a = { "mode" },
            lualine_b = { "filename", "branch", "diff" },
            lualine_c = {
                { function() return "%=" end }, -- spacer pushing the rest right
                { lsp_name, icon = " LSP:" },
                { "diagnostics", sources = { "nvim_diagnostic" } },
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
        },
    })
end

-- Breadcrumb bar at the top of each window.
function M.dropbar() require("dropbar").setup({}) end

-- Top buffer-tab bar.
function M.barbar()
    require("barbar").setup({
        icons = {
            buffer_index = true,
            buffer_numbers = true,
        },
    })
end

-- Vertical scrollbar on the right. No custom colors: nvim-scrollbar's own
-- defaults (Search, Diagnostic*, Normal) follow the colorscheme and the plugin
-- re-applies them on ColorScheme itself, so edge/onedark both work.
function M.scrollbar() require("scrollbar").setup() end

-- Indent guides + scope highlight.
function M.indent_blankline()
    require("ibl").setup({
        indent = {
            char = { "╎" },
            smart_indent_cap = true,
        },
        scope = {
            show_start = false,
            show_end = false,
            highlight = { "Function", "Label" },
        },
    })
end

-- Highlight of the current line / word.
function M.cursorline()
    local cursorword_hl = { underline = true }
    require("nvim-cursorline").setup({
        -- Delayed current-line highlight: off while moving, lit after `timeout`
        -- ms of no movement (keeps the screen calm).
        cursorline = {
            enable = true,
            timeout = 50,
            number = true,
        },
        -- Underline every occurrence of the word under the cursor.
        cursorword = {
            enable = true,
            min_length = 3,
            hl = cursorword_hl,
        },
    })
    -- nvim-cursorline only defines the CursorWord group once, at VimEnter.
    -- Every colorscheme here starts with `hi clear` (edge.vim and onedark's
    -- init both do), and sunset applies them from a timer *after* VimEnter,
    -- so the group loses its attributes and the underline silently disappears
    -- on every day/night switch. The group id survives `hi clear`, so simply
    -- re-applying the attributes makes the existing matchadd() work again.
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function() vim.api.nvim_set_hl(0, "CursorWord", cursorword_hl) end,
    })
end

-- edgy: turn side panels into fixed "docks" that do not get replaced when you
-- open files. left = file tree + outline, bottom = terminal, right = trouble.
function M.edgy()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = "screen" -- keep the view stable when opening splits
    require("edgy").setup({
        animate = { enabled = false },
        close_when_all_hidden = true,
        exit_when_last = true,
        wo = { winbar = false },
        left = {
            {
                ft = "neo-tree",
                pinned = true,
                collapsed = false,
                size = { height = 0.5, width = 0.12 },
                open = "Neotree show", -- command run when the dock is first shown
            },
            {
                ft = "Outline",
                pinned = true,
                collapsed = false,
                size = { height = 0.5, width = 0.12 },
                open = "Outline",
            },
        },
        bottom = {
            {
                ft = "toggleterm",
                pinned = true,
                collapsed = false,
                size = { height = 0.3 },
                -- only dock the horizontal (non-floating) toggleterm
                filter = function(_, win)
                    local cfg = vim.api.nvim_win_get_config(win)
                    local term = require("toggleterm.terminal").get(1)
                    return cfg.relative == "" and term.direction == "horizontal"
                end,
            },
        },
        right = {
            {
                ft = "trouble",
                pinned = false,
                collapsed = false,
                size = { width = 0.3 },
                open = "Trouble diagnostics toggle",
            },
        },
    })
end

-- Terminal (bottom docks / floating).
function M.toggleterm()
    require("toggleterm").setup()
end

return M
