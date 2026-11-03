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

-- catppuccin is only the engine for the day theme: it brings the coverage
-- (core UI groups, treesitter/LSP, ~70 per-plugin tables) and modules/ui/themes/
-- onehalf_latte.lua brings One Half Light's colours, with the grey ramp and
-- body contrast adjusted so it is not glaring (see that file for the numbers).
function M.catppuccin()
    local theme = require("modules.ui.themes.onehalf_latte")
    require("catppuccin").setup({
        flavour = "latte",
        color_overrides = { latte = theme.palette },
        highlight_overrides = { latte = theme.highlights },
    })
end

-- One Half Light on catppuccin's engine. `colors_name` is cleared first on
-- purpose: changing 'background' makes Neovim re-source the active colorscheme,
-- so the old theme would be re-applied for nothing before the switch.
function M.theme_day()
    vim.g.colors_name = nil
    vim.opt.background = "light"
    -- Before the theme, not after: catppuccin defines a couple of these
    -- (@lsp.type.enumMember and friends) and its definitions should win.
    fix_lsp_groups()
    vim.cmd.colorscheme("catppuccin-latte")
end

-- The dark theme defines the @lsp.* semantic-token groups explicitly (navarasu
-- colours `property` cyan and friends); nothing here overrides them, so they
-- would keep those colours in the light theme -- e.g. table keys in a Lua file
-- rendering pale cyan. Neovim already links every @lsp.type.X to its @X capture
-- by default, so dropping the leftovers puts the theme back in charge.
function fix_lsp_groups()
    for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
        if group:match("^@lsp%.") then
            pcall(vim.cmd, "hi clear " .. group)
        end
    end
end

-- The previous day theme, kept for A/B while the engine swap settles.
function M.theme_day_edge()
    vim.g.colors_name = nil
    vim.opt.background = "light"
    vim.cmd.colorscheme("edge")
end

-- navarasu/onedark, the dark theme this config has always used. The `style`
-- option has to be written through setup(): it lives in vim.g.onedark_config, so
-- `require("onedark").style = "dark"` is a silent no-op, and onedark pins
-- itself to "light" for as long as that option says "light".
--
-- The tab bar follows the structure of the WezTerm tab bar in
-- C:\Users\15089\.config\wezterm (utils/theme.lua): the strip is one step darker
-- than the working surface and the inactive tabs blend into it, while the active
-- tab is raised out of it. WezTerm raises its active tab with a saturated blue
-- because its window chrome is built on that blue; here the values are onedark
-- palette slots referenced as `$name` (onedark substitutes them with the active
-- style's colour), so the bar stays inside the theme: $bg_d for the strip, $bg3
-- for the active tab -- 1.46:1 against the strip, against 1.41:1 for $bg2 and
-- 1.24:1 for $bg1, i.e. the top of the range the palette has -- and $fg /
-- $light_grey for the two text levels.
function M.theme_night()
    vim.g.colors_name = nil
    vim.opt.background = "dark"
    require("onedark").setup({
        style = "warmer",
        highlights = {
            TabLine = { bg = "$bg_d", fg = "$light_grey" },
            TabLineFill = { bg = "$bg_d" },
            TabLineSel = { bg = "$bg3", fg = "$fg" },
        },
    })
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
            -- No "▎" separators between tabs: the tab surfaces already separate
            -- themselves, and the glyph is drawn in a colour of its own (barbar
            -- derives it from `Special`), which put a stray coloured line on the
            -- left edge of the active tab.
            separator = { left = "", right = "" },
            inactive = { separator = { left = "", right = "" } },
            separator_at_end = false,
            -- Per-buffer diagnostic counts, drawn after the file name: barbar's
            -- one place for them (its node order is fixed, so they cannot go on
            -- the left edge). The icons are lualine's own, so the tab bar and
            -- the status line use the same glyphs; all four severities are
            -- written out because barbar ships them disabled and only renders a
            -- severity whose count is above zero. The colours are not set here:
            -- barbar derives Buffer<state>{ERROR,WARN,INFO,HINT} from the
            -- Diagnostic* groups and keeps the tab's own background.
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "󰅚 " },
                [vim.diagnostic.severity.WARN] = { enabled = true, icon = "󰀪 " },
                [vim.diagnostic.severity.INFO] = { enabled = true, icon = "󰋽 " },
                [vim.diagnostic.severity.HINT] = { enabled = true, icon = "󰌶 " },
            },
        },
    })

    -- barbar derives its whole Buffer* colour family from the colorscheme's
    -- TabLine / TabLineSel, but a definition inside the colorscheme wins over
    -- that default link, and both themes here define these groups: onedark marks
    -- the current tab with bold text only, plus a purple Sign; catppuccin draws
    -- the tab text at overlay0. The result was a current tab with no background
    -- at all in the dark theme and an unreadable one in the light theme, leaving
    -- a single coloured "▎" to mark it. Re-point the family at barbar's own
    -- derived groups, so the tab colours come from the theme and no palette is
    -- duplicated here. Runs again on ColorScheme for the same reason as
    -- CursorWord: every colorscheme starts with `hi clear`.
    local function derive_tab_colors()
        require("barbar.highlight").resetup()
        for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
            if group:match("^Buffer") then
                local default = (group:gsub("^Buffer", "BufferDefault"))
                if vim.fn.hlexists(default) == 1 then
                    vim.api.nvim_set_hl(0, group, { link = default })
                end
            end
        end
        -- barbar paints the buffer index with `Special` and the rest of the
        -- secondary cells with NonText/Comment, which leaves a red digit inside
        -- the active tab (onedark's Special is #de5d68) and a 1.5:1 one on the
        -- light bar. WezTerm's tab bar draws the index in the tab's own
        -- foreground, so the index follows its tab -- again without naming a
        -- colour here.
        for _, state in ipairs({ "Current", "Visible", "Inactive", "Alternate" }) do
            vim.api.nvim_set_hl(0, "Buffer" .. state .. "Index", { link = "Buffer" .. state })
        end
    end

    derive_tab_colors()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = derive_tab_colors })
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
                    -- terminal 1 may not exist yet (`:ToggleTerm 2`), and this
                    -- runs from edgy's WinResized autocmd -> guard the lookup.
                    local term = require("toggleterm.terminal").get(1)
                    return cfg.relative == "" and term ~= nil and term.direction == "horizontal"
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

    -- edgy's own `exit_when_last = true` does not take effect on Neovim 0.12:
    -- while WinClosed runs, the window being closed is still returned by
    -- nvim_tabpage_list_wins(), so edgy's check_main() sees a main window and
    -- returns early, leaving the docks filling the screen after `:q`.
    -- Re-run that same check once the close has actually finished.
    vim.api.nvim_create_autocmd("WinClosed", {
        group = vim.api.nvim_create_augroup("edgy_exit_when_last", { clear = true }),
        callback = function()
            vim.schedule(function() require("edgy.editor").check_main() end)
        end,
    })
end

-- Terminal (bottom docks / floating).
function M.toggleterm()
    require("toggleterm").setup()
end

return M
