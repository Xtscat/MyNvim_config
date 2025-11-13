-- utils/coding/config.lua

local M = {}

local function get_root()
    return vim.fs.root(0, {
        "xmake.lua",
        "CMakeLists.txt",
        "Makefile",
        "Cargo.toml",
        "package.json",
        "pyproject.toml",
        "setup.py",
        ".git",
    }) or vim.fn.getcwd()
end

local function detect_project_command(root)
    if vim.fn.filereadable(root .. "/xmake.lua") == 1 then
        return "xmake && xmake run"
    elseif vim.fn.filereadable(root .. "/CMakeLists.txt") == 1 then
        local function detect_binary(root)
            local f = vim.fn.systemlist("find " .. root .. "/build -maxdepth 1 -type f -perm -111")[1]
            return f or (root .. "/build/a.out")
        end
        local binary = detect_binary(root)
        local build_dir = root .. "/build"
        if vim.fn.isdirectory(build_dir) == 0 then
            return string.format("cmake -S . -B build && cmake --build build && %s", binary)
        else
            return string.format("cmake --build build && %s", binary)
        end
    elseif vim.fn.filereadable(root .. "/Makefile") == 1 then
        return "make run || (make && ./a.out)"
    elseif vim.fn.filereadable(root .. "/Cargo.toml") == 1 then
        return "cargo build && cargo run"
    elseif vim.fn.filereadable(root .. "/package.json") == 1 then
        return "(test -d node_modules || npm install) && (npm run start || node .)"
    elseif vim.fn.filereadable(root .. "/pyproject.toml") == 1
        or vim.fn.filereadable(root .. "/setup.py") == 1 then
        if vim.fn.filereadable(root .. "/poetry.lock") == 1 then
            return "poetry install && poetry run python main.py"
        else
            return "python3 main.py"
        end
    else
        return "make && ./a.out"
    end
end

local function update_project_config()
    local root = get_root()
    if not root or root == "" then
        return
    end

    local command = detect_project_command(root)
    local name = vim.fs.basename(root)

    return command, name
end

function M.code_runner_config()
    local command, name = update_project_config()
    local root = get_root()
    require("code_runner").setup({
        mode = "toggleterm", -- 可改为 "better_term"、"toggleterm"、"tab"、"vimux"
        focus = true,
        startinsert = true,
        project = {
            [root] = {
                name = name,
                description = "Auto-detected project",
                command = command,
            },
        },
    })
end

function M.leetcode_config()
    require("leetcode").setup({
        arg = 'leetcode.nvim',
        lang = 'cpp',
        cn = {
            enabled = true,
            translator = true,
            translate_problems = true,
        },
        editor = {
            reset_previous_code = true, ---@type boolean
            fold_imports = false, ---@type boolean
        },
        theme = {
            ["alt"] = {
                bg = "#FAFAFA",
                fg = "#000000"
            },
            -- ["normal"] = {
            -- }
        }
    })
end

return M
