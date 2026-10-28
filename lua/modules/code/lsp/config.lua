-- modules/code/lsp/config.lua
--
-- Language-server setup and diagnostic display. Uses Neovim 0.11+ APIs
-- (vim.lsp.config / vim.lsp.enable), so it needs Neovim >= 0.11.

local M = {}

-- mason is only the installer/UI for language servers and formatters.
-- The servers themselves are configured by hand below (no mason-lspconfig).
function M.mason() require("mason").setup() end

function M.lsp()
    -- Start from Neovim's defaults, then let blink.cmp advertise what it
    -- supports (extra completion item kinds, snippet support, ...).
    local base_capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require("blink.cmp").get_lsp_capabilities(base_capabilities)

    -- One entry per language server. Keys are the server names used by
    -- vim.lsp.config/enable. Only servers that are actually installed and
    -- wanted are listed here.
    local servers = {
        -- Lua
        emmylua_ls = {
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },                          -- we run LuaJIT
                    diagnostics = { globals = { "vim" } },                     -- don't flag `vim` as undefined
                    workspace = { library = vim.api.nvim_get_runtime_file("", true) }, -- know neovim's own API
                },
            },
        },

        -- C / C++
        -- Kept for reference: clice is not mature yet, may switch back to clangd.
        -- (mason package removed; reinstall with :MasonInstall clangd if switching back)
        -- clangd = {
        --     cmd = {
        --         "clangd",
        --         "--background-index",
        --         "--completion-style=detailed",
        --         "--all-scopes-completion",
        --         "--header-insertion=iwyu",
        --     },
        -- },
        -- No hand-written clice config: nvim-lspconfig ships one in lsp/clice.lua
        -- (cmd, filetypes c/cpp/cuda, root_markers clice.toml /
        -- compile_commands.json / .git) plus the :LspClice{Show,Switch,Reset}Context
        -- and :LspCliceSwitchConfiguration commands via on_attach. Our own copy had
        -- clangd's markers (compile_flags.txt, configure.ac, .clang-tidy,
        -- .clang-format) -- which make a subdirectory the workspace root -- a typo
        -- ("clide.toml") and offsetEncoding = utf-8 while clice answers in UTF-16.
        --
        -- clice has no user-level config file: settings come from the
        -- workspace's clice.toml or from the client's initializationOptions,
        -- and this is the only place that reaches every project at once.
        -- No index rules here: every TU in the compilation database joins the
        -- index, which is what lets a cross-file gd land in any .cpp -- the
        -- index, and not the open document's AST, answers it. A rule saying
        -- `index = false` does not just skip indexing: it DROPS the rows the
        -- index already holds for the matching TUs, so add one only for trees
        -- that must never be a jump target, and expect to pay their rebuild
        -- again the day the rule goes away.
        clice = {
            -- lspconfig's root_markers stop at the nearest ancestor, and
            -- third_party/llvm-project carries its own .git: a header opened
            -- there became a workspace of its own, which has no
            -- compile_commands.json -- so clice guessed the flags and had
            -- nothing to index. clice derives its whole index from the
            -- compilation database, so take the nearest ancestor that has one
            -- (at its root or in an immediate subdirectory, the usual build/
            -- layout) and only fall back to the marker-based root if there is
            -- none.
            root_dir = function(bufnr, on_dir)
                local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
                while dir and dir ~= "/" and dir ~= "" do
                    local found = vim.fn.filereadable(dir .. "/compile_commands.json") == 1
                        or #vim.fn.glob(dir .. "/*/compile_commands.json", true, true) > 0
                    if found then return on_dir(dir) end
                    if dir == vim.env.HOME then break end
                    dir = vim.fs.dirname(dir)
                end
                on_dir(vim.fs.root(bufnr, { "clice.toml", "compile_commands.json", ".git" }))
            end,
        },

        -- Python
        ty = {},

        -- Bash
        bashls = {
            bash = {
                diagnostics = { enable = true },
                completion = { enable = true },
            },
        },
    }

    -- Register and enable each server. blink's capabilities are merged in as a
    -- default so every server gets them (per-server `capabilities` wins).
    for server_name, config in pairs(servers) do
        local server_config = vim.tbl_deep_extend("force", {
            capabilities = capabilities,
        }, config)
        vim.lsp.config(server_name, server_config)
        vim.lsp.enable(server_name)
    end

    -- Diagnostic display policy:
    --   underline      -> mark the offending range on the code (visible at a glance)
    --   virtual_text   -> OFF (no inline message pushed to end of line)
    --   virtual_lines  -> OFF (no message line inserted below)
    --   float          -> ON, shown on demand via <leader>d
    -- Read the full message with <leader>d (open_float) or browse all with
    -- <leader>t (trouble).
    vim.diagnostic.config({
        float = { border = "none" },
        severity_sort = true,
        underline = true,
        virtual_text = false,
        virtual_lines = false,
    })
end

-- LSP progress spinner in the corner.
function M.fidget() require("fidget").setup({}) end

function M.trouble()
    require("trouble").setup({ auto_preview = false })
end

return M
