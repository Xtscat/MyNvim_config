-- modules/ui/themes/onehalf_latte.lua
--
-- One Half Light, carried by catppuccin's engine (see modules/ui/config.lua).
-- Catppuccin supplies the structure -- three layers of coverage (core UI groups
-- incl. the Neovim 0.12 ones, treesitter/LSP, ~70 per-plugin tables) -- and this
-- file supplies the colours.
--
-- The hues are One Half Light's own, from the theme's definitions:
--   * VSCode:  vscode/onehalf-light/themes/OneHalfLight.tmTheme
--              keyword/storage #A626A4, function #0184BC, string #50A14F,
--              number/class/constant #C18401, variable/tag #E45649,
--              parameter #383A42, comment #A0A1A7, escape #0997B3,
--              selection #BFCEFF, line highlight #F0F0F0
--   * Vim:     vim/colors/onehalflight.vim (same palette, #fafafa background)
--
-- ...with the three things that made it glare on a full screen fixed, all
-- measured against the `edge` light theme this config was happy with:
--
--                         One Half      edge          this theme
--   editor background     #fafafa       #fafafa       #f1f2f4  (-6.3% light)
--   body text contrast    10.1:1        7.2:1         8.32:1
--   panel step            ~0%            ~4.7%         5.4%   (mantle)
--   chrome/separator step ~0%            ~7.6%         8.3%   (crust)
--   accent saturation     0.77-0.99     0.55-0.65     0.59-0.94
--
-- Two consequences of catppuccin's structure worth knowing:
--   * It has 26 colour slots (14 accents + text/subtext0-1 + overlay0-2 +
--     surface0-2 + base/mantle/crust) while One Half only has 6 hues and a few
--     greys, so hues are reused across slots exactly like the original reuses
--     them across captures.
--   * The greys are the load-bearing part: `mantle` paints floats/pickers/docks
--     and the status line, `crust` the tabline and window separators. Making
--     them equal to the background (or too far from it) is what produces
--     "no depth / grey boxes" -- hence the two explicit steps above.

local M = {}

-- One Half hues: saturation x0.95 of the original and lightness x0.96, i.e.
-- deeper than Atom's originals (which vibrate on light backgrounds) without
-- going as pale as a plain desaturation.
local RED = "#de5043" -- #e45649
local GREEN = "#4f994e" -- #50a14f
local AMBER = "#b57d06" -- #c18401 (types, numbers, constants)
local BLUE = "#057db0" -- #0184bc (functions)
local PURPLE = "#9c289a" -- #a626a4 (keywords, storage)
local CYAN = "#0d8ea8" -- #0997b3 (escapes, preproc)
local TEXT = "#43474f" -- #383a42, softened to ~8.32:1 on the new base

M.palette = {
    -- surfaces: editor / panels / chrome
    base = "#f1f2f4",
    mantle = "#dee1e5",
    crust = "#d4d8de",
    surface0 = "#ccd1d8",
    surface1 = "#b8bdc5",
    surface2 = "#aeb3bc",

    -- text
    text = TEXT,
    subtext1 = "#535861",
    subtext0 = "#656a73",
    overlay2 = "#97989e", -- One Half's comment colour, a touch deeper
    overlay1 = "#a2a6ad",
    overlay0 = "#adb1b9",

    -- accents (see the mapping in the header)
    red = RED,
    maroon = "#c94a3e",
    peach = AMBER,
    yellow = AMBER,
    green = GREEN,
    teal = CYAN,
    sky = CYAN,
    sapphire = BLUE,
    blue = BLUE,
    mauve = PURPLE,
    pink = CYAN, -- preproc / string escapes are cyan in One Half
    flamingo = RED, -- Identifier
    lavender = RED, -- Tag, @property, @variable.member -- all red in One Half
    rosewater = BLUE, -- cursor block / winbar (blue, as in the Vim theme)
}

-- Helpers for the two override groups below.
local function tint(color, amount)
    -- Blend `color` into the background: catppuccin's own way of making the
    -- soft diff/conflict backgrounds.
    local base = M.palette.base
    local function parse(h)
        return {
            tonumber(h:sub(2, 3), 16),
            tonumber(h:sub(4, 5), 16),
            tonumber(h:sub(6, 7), 16),
        }
    end
    local b, c = parse(base), parse(color)
    local out = {}
    for i = 1, 3 do
        out[i] = math.floor(b[i] + (c[i] - b[i]) * amount + 0.5)
    end
    return string.format("#%02x%02x%02x", out[1], out[2], out[3])
end

-- Groups where catppuccin's slot mapping differs from One Half's own mapping,
-- plus the groups that are *not* in catppuccin's tables and that plugins derive
-- from the theme themselves -- those keep whatever the previous colourscheme
-- left behind, which after a switch from the dark theme means black blocks in a
-- light UI. `Terminal` is the terminal buffer's Normal, `NeoTreeEndOfBuffer`
-- paints the empty rows of the file-tree dock, `OutlineCurrent` the current
-- symbol, the GitConflict* set the conflict markers, `Pmenu`/`BlinkCmpLabel`
-- the completion menu's text (catppuccin leaves those at comment grey).
M.highlights = {
    -- One Half's selection (#bfceff) instead of catppuccin's surface1 + bold.
    Visual = { bg = "#bfceff" },
    VisualNOS = { bg = "#bfceff" },

    -- One Half keeps operators and parameters at the body colour.
    Operator = { fg = TEXT },
    ["@operator"] = { fg = TEXT },
    ["@variable.parameter"] = { fg = TEXT },
    CursorLineNr = { fg = TEXT },

    -- ...and paints plain variables red (catppuccin: body colour).
    ["@variable"] = { fg = RED },

    -- Links/quotes are green there, not the lavender catppuccin uses.
    ["@markup.link"] = { fg = GREEN },

    -- Blue + underline, like the original.
    MatchParen = { fg = BLUE, underline = true },

    -- Search: One Half's amber, softened to 25/40/60% over the background
    -- instead of the original solid amber block (the harshest thing in it).
    Search = { bg = "#e4d6bc", fg = TEXT },
    IncSearch = { bg = "#dcc69a", fg = TEXT },
    CurSearch = { bg = "#d2b06c", fg = TEXT },

    -- Completion menu: the item text is body-coloured in One Half (and easier
    -- to read than catppuccin's overlay2), descriptions stay muted.
    Pmenu = { bg = M.palette.mantle, fg = TEXT },
    PmenuExtra = { fg = M.palette.overlay1 },
    PmenuMatch = { fg = TEXT, bold = true },
    BlinkCmpLabel = { fg = TEXT },
    BlinkCmpLabelDescription = { fg = M.palette.overlay1 },
    BlinkCmpLabelDetail = { fg = M.palette.overlay1 },

    -- Terminal buffer / legacy terminal statusline (dark after a theme switch).
    Terminal = { fg = TEXT, bg = M.palette.base },
    StatusLineTerm = { fg = TEXT, bg = M.palette.mantle },
    StatusLineTermNC = { fg = M.palette.surface1, bg = M.palette.mantle },

    -- neo-tree derives these from the active theme when the window is created
    -- and never re-derives them, so the empty part of the dock kept onedark's
    -- #21252b -- i.e. a black block under the file tree.
    NeoTreeEndOfBuffer = { fg = M.palette.mantle, bg = M.palette.mantle },
    NeoTreeVertSplit = { fg = M.palette.base, bg = M.palette.mantle },
    NeoTreeStatusLineNC = { fg = M.palette.mantle, bg = M.palette.mantle },

    -- outline.nvim only references these; onedark was the last theme to define
    -- them, so they stayed dark too.
    OutlineCurrent = { bg = M.palette.surface0 },
    OutlineGuides = { fg = M.palette.surface1 },

    -- git-conflict markers (onedark's dark green/blue/purple set otherwise).
    GitConflictCurrentLabel = { bg = tint(GREEN, 0.28) },
    GitConflictCurrent = { bg = tint(GREEN, 0.14) },
    GitConflictIncomingLabel = { bg = tint(BLUE, 0.28) },
    GitConflictIncoming = { bg = tint(BLUE, 0.14) },
    GitConflictAncestorLabel = { bg = tint(PURPLE, 0.28) },
    GitConflictAncestor = { bg = tint(PURPLE, 0.14) },

    -- gitsigns' staged-diff preview (same stale-group story).
    GitSignsDiffStaged = { link = "DiffChange" },
}

return M
