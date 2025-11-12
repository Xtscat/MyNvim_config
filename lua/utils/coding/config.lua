-- utils/coding/config.lua
-- 自动项目运行配置 for code_runner.nvim
-- 分离辅助函数，稳定执行

local M = {}

------------------------------------------------------------
-- 辅助函数部分
------------------------------------------------------------

-- 自动项目根目录检测函数
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

-- 根据项目内容选择正确的运行命令
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

-- 生成完整的 code_runner 配置（可以在 BufEnter 中重复调用）
local function update_project_config()
    local root = get_root()
    if not root or root == "" then
        return
    end

    local command = detect_project_command(root)
    local name = vim.fs.basename(root)

    return command, name
end

------------------------------------------------------------
-- 导出模块方法
------------------------------------------------------------

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

return M
