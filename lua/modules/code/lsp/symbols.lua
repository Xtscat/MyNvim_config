-- modules/code/lsp/symbols.lua
--
-- "Jump to the next / previous symbol" for the current buffer, driven by the
-- LSP `textDocument/documentSymbol` request. No outline UI has to be open.
--
-- A symbol has to start strictly after (before) the cursor to count, so
-- pressing `next` from the middle of a function body lands on the *next*
-- function, and `prev` right after such a jump comes back.

local M = {}

-- Jump targets, written as vim.lsp.protocol.SymbolKind names. Grouped per
-- filetype because the same concept has a different kind in each language --
-- this is the only language-dependent part of the module, which is why the
-- keymaps stay language-neutral.
--   default  the funcs / types that most servers report
--   lua      emmylua_ls reports tables (including the "classes" built with
--            setmetatable) as Object(19) and their methods as Function(12);
--            there is no Class / Method. Measured on a mod.lua: M / Point /
--            Shape -> Object, M.public_fn -> Function.
local KINDS = {
    default = {
        funcs = { "Function", "Method", "Constructor" },
        types = { "Class", "Struct", "Enum", "EnumMember", "Interface", "TypeParameter" },
    },
    lua = {
        funcs = { "Function", "Constructor" },
        types = { "Object", "Class", "Interface" },
    },
}

local GROUPS = { all = true, funcs = true, types = true }

-- group: "all" (funcs + types) | "funcs" | "types"
--
-- Unknown groups are an error, not an empty filter: a typo here would
-- otherwise turn every jump into a silent no-op.
local function kind_filter(group)
    assert(GROUPS[group], ("symbols: unknown kind group %s"):format(vim.inspect(group)))
    local per = KINDS[vim.bo.filetype] or KINDS.default
    local names = {}
    if group == "all" then
        vim.list_extend(names, per.funcs)
        vim.list_extend(names, per.types)
    else
        vim.list_extend(names, per[group])
    end

    local set = {}
    for _, name in ipairs(names) do
        local n = vim.lsp.protocol.SymbolKind[name]
        if n then
            set[n] = true
        end
    end
    return set
end

-- Walk the (possibly nested) DocumentSymbol tree in document order: a class
-- comes before its members, so inside a class body the members are visited in
-- order. A filtered-out parent (a namespace in a .cpp, for example) does not
-- hide its children, and servers that answer with a flat SymbolInformation[]
-- list are handled too.
local function flatten(symbols, kinds, out)
    for _, s in ipairs(symbols) do
        local range = s.range or (s.location and s.location.range)
        if range and kinds[s.kind] then
            out[#out + 1] = { line = range.start.line, col = range.start.character }
        end
        if s.children then
            flatten(s.children, kinds, out)
        end
    end
    table.sort(out, function(a, b)
        return a.line < b.line or (a.line == b.line and a.col < b.col)
    end)
    return out
end

-- Symbols are re-fetched on every jump instead of cached: one documentSymbol
-- request per keypress is cheap, and a cache would have to be invalidated on
-- every edit.
local function fetch(bufnr, group, cb)
    if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentSymbol" }) == 0 then
        cb(nil) -- no server here is able to list symbols
        return
    end
    -- buf_request calls the handler once per supporting client; only the first
    -- answer is used, so a second attached server cannot move the cursor again.
    local replied = false
    vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", {
        textDocument = vim.lsp.util.make_text_document_params(bufnr),
    }, function(err, result)
        if replied then
            return
        end
        replied = true
        cb(err and nil or flatten(result or {}, kind_filter(group), {}))
    end)
end

-- The count-th symbol strictly before/after (line, col) in document order.
-- Nil when there is nothing left in that direction (no wrap-around).
local function pick(symbols, direction, line, col, count)
    local matches = {}
    for _, s in ipairs(symbols) do
        -- Both comparisons are strict: landing exactly on a symbol's start means
        -- `next` skips it and `prev` does not jump back to it, so a jump always
        -- moves the cursor.
        local after = s.line > line or (s.line == line and s.col > col)
        local before = s.line < line or (s.line == line and s.col < col)
        if (direction == "next" and after) or (direction == "prev" and before) then
            matches[#matches + 1] = s
        end
    end
    if direction == "prev" then
        for i = 1, math.floor(#matches / 2) do
            local j = #matches - i + 1
            matches[i], matches[j] = matches[j], matches[i]
        end
    end
    return matches[math.min(count, #matches)] -- clamps at the last one, like a motion
end

-- The symbol list of a buffer, for tests and for any future picker of ours.
function M.list(bufnr, group, cb)
    fetch(bufnr or 0, group, cb)
end

-- direction: "next" | "prev"; group: "all" | "funcs" | "types"
function M.jump(direction, group, count)
    assert(
        direction == "next" or direction == "prev",
        ("symbols: direction must be 'next' or 'prev', got %s"):format(vim.inspect(direction))
    )
    fetch(0, group, function(symbols)
        if not symbols then
            vim.notify("No LSP client here supports document symbols", vim.log.levels.WARN)
            return
        end
        local cur = vim.api.nvim_win_get_cursor(0)
        local target = pick(symbols, direction, cur[1] - 1, cur[2], count or 1)
        if not target then
            vim.notify(direction == "next" and "No next symbol" or "No previous symbol", vim.log.levels.INFO)
            return
        end
        vim.cmd("normal! m'") -- push the jumplist, so <C-o> comes back
        vim.api.nvim_win_set_cursor(0, { target.line + 1, target.col })
        vim.cmd("normal! zv") -- open folds so the target is visible
    end)
end

return M
