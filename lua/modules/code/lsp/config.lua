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
        clice = {
            cmd = { "clice", "serve" },
            filetypes = { "c", "cpp" },
            -- Where clice looks for the project root; first match wins per dir.
            root_markers = {
                ".git/",
                "clide.toml",
                ".clang-tidy",
                ".clang-format",
                "compile_commands.json",
                "compile_flags.txt",
                "configure.ac",
            },
            capabilities = {
                textDocument = { completion = { editsNearCursor = true } },
                offsetEncoding = { "utf-8" },
            },
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
