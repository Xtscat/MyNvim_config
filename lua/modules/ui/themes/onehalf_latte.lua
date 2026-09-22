-- modules/ui/themes/onehalf_latte.lua
--
-- One Half Light, carried by catppuccin's engine (see modules/ui/config.lua).
-- Catppuccin supplies the structure -- three layers of coverage (core UI groups
-- incl. the Neovim 0.12 ones, treesitter/LSP, ~70 per-plugin tables) -- and this
-- file supplies the colours.
--
-- The colours are One Half Light's, from the theme's own definitions:
--   * VSCode:  vscode/onehalf-light/themes/OneHalfLight.tmTheme
--              keyword/storage #A626A4, function #0184BC, string #50A14F,
--              number/class/constant #C18401, variable/tag #E45649,
--              parameter #383A42, comment #A0A1A7, escape #0997B3,
--              selection #BFCEFF, line highlight #F0F0F0
--   * Vim:     vim/colors/onehalflight.vim (same palette, #fafafa background)
--
-- ...but with the three things that made it glaring on a full screen fixed, all
-- three measured against the `edge` light theme that this config was happy with:
--
--                         One Half      edge          this theme
--   editor background     #fafafa       #fafafa       #f1f2f4  (-6.3% light)
--   body text contrast    10.1:1        7.2:1         7.45:1
--   panel step            ~0%            ~4.7%         4.4%   (mantle)
--   chrome/separator step ~0%            ~7.6%         7.0%   (crust)
--   accent saturation     0.77-0.99     0.55-0.65     0.53-0.85
--
-- Two consequences of catppuccin's structure worth knowing:
--   * It has 26 colour slots (14 accents + text/subtext0-1 + overlay0-2 +
--     surface0-2 + base/mantle/crust) while One Half only has 6 hues and a few
--     greys, so hues are reused across slots exactly like the original reuses
--     them across captures.
--   * The greys are the load-bearing part: `mantle` paints floats/pickers/docks
--     and the status line, `crust` the tabline and window separators. Setting
--     them to the background (or too far from it) is what produces "no depth /
--     grey boxes" -- hence the two explicit steps above.

local M = {}

-- One Half hues, saturation x0.85 (the originals are Atom's, which vibrate on a
-- light background).
local RED = "#d96156" -- #e45649
local GREEN = "#569b55" -- #50a14f
local AMBER = "#bd8412" -- #c18401 (types, numbers, constants)
local BLUE = "#0f7eae" -- #0184bc (functions)
local PURPLE = "#9c309b" -- #a626a4 (keywords, storage)
local CYAN = "#168ea6" -- #0997b3 (escapes, preproc)
local TEXT = "#4a4e56" -- #383a42, softened for ~7.45:1 on the new base

M.palette = {
    -- surfaces: editor / panels / chrome
    base = "#f1f2f4",
    mantle = "#e2e4e8",
    crust = "#d9dce2",
    surface0 = "#d3d7dd",
    surface1 = "#c2c6cd", -- gutter / unfocused text: visible (~1.55:1), unlike One Half's #d4d4d4
    surface2 = "#b8bcc4",

    -- text
    text = TEXT,
    subtext1 = "#5a5f68",
    subtext0 = "#6c717a",
    overlay2 = "#a0a1a7", -- One Half's comment colour, unchanged
    overlay1 = "#adb0b6",
    overlay0 = "#b8bbc2",

    -- accents (see the mapping in the header)
    red = RED,
    maroon = "#c9564e",
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

-- Groups where catppuccin's slot mapping differs from One Half's own mapping.
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
    -- instead of the original solid amber block (which is the harshest thing in
    -- the original light theme).
    Search = { bg = "#e4d6bc", fg = TEXT },
    IncSearch = { bg = "#dcc69a", fg = TEXT },
    CurSearch = { bg = "#d2b06c", fg = TEXT },
}

return M
