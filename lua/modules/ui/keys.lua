-- modules/ui/keys.lua
--
-- Keymaps for the UI module (buffer tabs, terminal, window picker).
-- Registered once at startup by the loader (see lua/modules/init.lua).

local Map = require("utils.map").with_prefix("UI")
local M = {}

function M.register()
    -- barbar: close / pick
    Map.nmap("<leader>pb", [[<Cmd>BufferPickDelete<CR>]], "Pick & Close")
    Map.nmap("<leader>cb", [[<Cmd>BufferClose<CR>]], "Close Current")
    Map.nmap("<leader>x[", [[<Cmd>BufferCloseBuffersLeft<CR>]], "Close All to the Left")
    Map.nmap("<leader>x]", [[<Cmd>BufferCloseBuffersRight<CR>]], "Close All to the Right")

    -- barbar: switch / move
    Map.nmap("\\[", "<Cmd>BufferPrevious<CR>", "Previous Buffer")
    Map.nmap("\\]", "<Cmd>BufferNext<CR>", "Next Buffer")
    Map.nmap("\\{", "<Cmd>BufferMovePrevious<CR>", "Move Buffer Left")
    Map.nmap("\\}", "<Cmd>BufferMoveNext<CR>", "Move Buffer Right")

    -- barbar: quick jump (<leader>1 .. <leader>9, and <leader>0 for last)
    for i = 1, 9 do
        Map.nmap("<leader>" .. i, ("<Cmd>BufferGoto %d<CR>"):format(i), "Go to Buffer " .. i)
    end
    Map.nmap("<leader>0", [[<Cmd>BufferLast<CR>]], "Go to Last Buffer")

    -- toggleterm
    Map.nmap("<leader>T", "<cmd>ToggleTerm<CR>", "Open Terminal")

    -- ================================================================
    -- <leader>fw : focus a window by pressing an on-screen label.
    --
    -- Pure Lua (replaces the Rust nvim_winpick plugin, whose prebuilt
    -- binary segfaulted on Neovim 0.12). How it works:
    --   1. collect every "normal" window (skip floating ones)
    --   2. open a small badge float in the top-left of each window,
    --      showing one label character
    --   3. block on getcharstr() until the user presses a key
    --   4. close all badges, focus the window matching that key
    -- ================================================================
    Map.nmap("<leader>fw", function()
        -- 1. candidates: normal split windows only (relative == "" means not a float)
        local wins = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(win).relative == "" then
                wins[#wins + 1] = win
            end
        end
        if #wins < 2 then
            return -- nothing to pick between
        end

        local chars = "FJDKSLA;CMRUEIWOQP" -- home-row-ish labels, one per window
        -- Badge size in cells; make these bigger if the labels are hard to spot.
        local label_w, label_h = 3, 3
        local pad = string.rep(" ", label_w)
        local mid = math.floor(label_h / 2) + 1 -- row that holds the letter

        local label_of = {} -- character -> window id
        local cleanup = {}  -- functions that close the badge floats/buffers

        -- 2. one badge float per window
        for i, win in ipairs(wins) do
            local ch = chars:sub(i, i)
            if ch == "" then
                break -- more windows than we have labels for
            end
            label_of[ch] = win

            -- the badge body: a label_h x label_w block with the letter centred
            local lines = {}
            for row = 1, label_h do
                lines[row] = (row == mid) and (" " .. ch .. " ") or pad
            end

            local buf = vim.api.nvim_create_buf(false, true) -- scratch buffer
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

            -- relative="win" positions the float relative to the target window,
            -- row/col 0 = its top-left, so the badge sits over the first line.
            local ok, fwin = pcall(vim.api.nvim_open_win, buf, false, {
                relative = "win",
                win = win,
                row = 0,
                col = 0,
                width = label_w,
                height = label_h,
                style = "minimal",
                focusable = false,
                noautocmd = true,
                zindex = 200, -- draw above normal windows
            })
            if ok then
                -- Map the badge's Normal highlight to Search -> a solid, visible block.
                vim.api.nvim_set_option_value("winhighlight", "Normal:Search", { win = fwin })
                cleanup[#cleanup + 1] = function()
                    if vim.api.nvim_win_is_valid(fwin) then
                        vim.api.nvim_win_close(fwin, true)
                    end
                    if vim.api.nvim_buf_is_valid(buf) then
                        vim.api.nvim_buf_delete(buf, { force = true })
                    end
                end
            else
                -- couldn't open a badge for this window; just drop its buffer
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end

        -- 3. make sure the badges are painted, then wait for one keypress
        vim.cmd("redraw")
        local ok, key = pcall(vim.fn.getcharstr)

        -- 4. always tear the badges down, even if the key read was interrupted
        for _, fn in ipairs(cleanup) do
            pcall(fn)
        end

        if ok then
            local target = label_of[key] -- nil if the key was not a label (e.g. Esc)
            if target and vim.api.nvim_win_is_valid(target) then
                vim.api.nvim_set_current_win(target)
            end
        end
    end, "Find Window")
end

return M
