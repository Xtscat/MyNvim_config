# nvim-remake

Neovim 配置重构记录。本文档记录 2026-09 这次重构的**目标、架构、分类决策、UI 细节、性能数据、离线部署方案和待办**，供以后（人或 AI）接手时理解"为什么是这样"。

- 新配置：`~/.config/nvim`（本目录）
- 仓库：remote `git@github.com:Xtscat/MyNvim_config.git`；重构已经 **PR #1** 合入 `master`（`remake` 分支已删），之后直接在 `master` 上提交／推送
- 旧配置：`~/.config/nvim-old`（独立副本，未改动）
- 参考的另一份精简配置：`~/.config/nvim-bare`（基于 Neovim 0.12 内置 `vim.pack`，未纳入本次重构）

---

## 1. 为什么重构

旧配置的结构是"两棵树靠文件名同步"：

```
lua/plugins/init.lua   -- 插件清单，按功能桶分组（base/edit/ui/lsp/window/navigation/...）
lua/configs/<桶>.lua   -- 同名的 setup + keymaps
```

问题：

1. **分类只是标签，不影响任何加载行为** —— `defaults = { lazy = false }` 让所有插件启动即载，桶名纯粹是变量名。
2. **同一分类拆在两棵树里靠命名同步**，已经漂移：插件组 `markdown`/`latex` ↔ 配置文件 `md`/`tex`。
3. **`with_config_and_keys` 吞掉返回值和错误**，制造了真实 bug（见 §5）。
4. **`join()` 用 `ipairs`**，遇到中间某个 `nil`（被注释掉的 ipynb）就静默丢弃后面所有组（hex 整组没加载）。
5. 边界混乱：git 插件放在 `ui`，terminal 放在 `window`，搜索高亮放在 `edit`。

---

## 2. 最终架构

### 2.1 目录树

```
init.lua                       -- options -> commands -> keymaps -> autocmds -> lazy
lua/
  core/
    options.lua                -- vim.opt / vim.g（含剪切板）
    commands.lua               -- :Vsp / :Hsp 等通用命令
    keymaps.lua                -- 全局键位（不属于任何插件的）
    autocmds.lua               -- 全局 autocmd
    lazy.lua                   -- lazy.nvim bootstrap + spec = require("modules").specs()
  utils/map.lua                -- 键位封装（with_prefix 给 which-key 分组用）
  modules/
    init.lua                   -- loader：唯一加载顺序来源
    deps/                      spec
    snacks/                    spec config        -- picker/input 引擎
    treesitter/                spec config        -- parser 安装/高亮（唯一需 gcc+git 的模块）
    ui/                        spec config keys   -- 主题/状态栏/tabline/winbar/缩进/滚动/cursorline/window(edgy)/terminal(toggleterm)/winpick
    editor/                    spec config        -- Comment/autopairs/mini.ai/neotab/toggler/autosave/lastplace
    nav/                       spec config keys   -- snacks picker 键位/neo-tree/outline/hlslens/haunt
    git/                       spec config keys   -- gitsigns/git-conflict
    code/
      lsp/                     spec config keys   -- nvim-lspconfig/mason/fidget/trouble
      completion/              spec config        -- blink.cmp / friendly-snippets
      format/                  spec config keys   -- conform
    ft/
      markdown/                spec config keys   -- render-markdown / smark
    build/                     spec config keys   -- cmake-tools
after/ftplugin/{c,cpp,cuda}.lua                    -- 纯 buffer-local 选项（2 空格缩进）
formatters/                                        -- 从 $HOME 抄来的全局格式化配置（打包用）
lazy-lock.json
```

### 2.2 模块契约

每个模块是一个目录，固定三种文件：

| 文件 | 必需 | 作用 |
|---|---|---|
| `spec.lua` | ✅ | 返回 lazy.nvim 插件列表。`config = function() require("modules.X.config").fn() end` |
| `config.lua` | 可选 | 返回 setup 函数表 |
| `keys.lua` | 可选 | 返回 `{ register = function() ... end }`，**启动时调用一次**，与插件是否加载无关 |

- `lua/modules/init.lua` 里的 `order` 列表是**唯一加载顺序来源**。新增模块 = 加目录 + 在 `order` 里加一行。
- loader 用 `require` 直接加载（不再 `pcall` 吞错），spec 失败会明确报出模块名。
- `keys.lua` 用 `vim.fn.stdpath("config")` 探测是否存在，存在才 require；文件内语法错误会正常抛出。

### 2.3 加载顺序

```lua
order = {
  "deps", "snacks", "treesitter", "ui", "editor", "nav", "git",
  "code.completion", "code.lsp", "code.format", "ft.markdown", "build",
}
```

`defaults = { lazy = false }`，个别插件用 `event` / `cmd` / `ft` 显式懒加载。

### 2.4 键位前缀（which-key 分组）

`Core` / `UI` / `Nav` / `Git` / `LSP` / `Format` / `CMake` / `Markdown`
（`editor` 无 `keys.lua`，用各插件自带键位。）

主要入口：

| 前缀 | 内容 |
|---|---|
| `<leader>l` | 复制当前文件绝对路径 |
| `ah/aj/ak/al` | 窗口焦点；`H`/`L` 行首尾；`<C-j>`/`<C-k>` 滚动 1/4 屏 |
| `<leader>ff` / `<leader>fc` | snacks picker 找文件 / 找代码 |
| `tt` / `<leader>e` / `<leader>a` | neo-tree 开关 / reveal / outline |
| `n` `N` `<Esc>` | hlslens 下一个 / 上一个 / 清除高亮 |
| `<leader>n*` | haunt.nvim 笔记（`na` 加 note、`nl` 列表、`nq` quickfix…） |
| `gd gD gr gR` / `<leader>rn` / `<leader>t` / `<leader>d` | LSP 跳转 / 重命名 / trouble / 诊断浮窗 |
| `<c-l>` | 格式化 |
| `<leader>g*` | git-conflict（next/prev/ours/theirs/both/none） |
| `<leader>1-9/0` | barbar 切 buffer；`<leader>pb/cb/x[/x]`；`\[ \] \{ \}` |
| `<leader>T` / `<leader>fw` | toggleterm / winpick |
| `<leader>C*` | CMake |

命令：`:Vsp` / `:Hsp`（从 buffer 或同目录文件选一个 split 打开）、`:Format`。

### 2.5 剪切板（WSL / SSH / 本地）

设置入口在 `core/options.lua` 末尾；copy 的公共逻辑抽象在 `lua/utils/clipboard.lua`（`is_ssh` / `osc52` / `yank`），所有 copy 路径都该走它。思路是尽量不配置：

- **WSL / 本地 Linux 桌面**：不写任何东西。Neovim 内置探测本来就按 `win32yank.exe`（WSL）→ `wl-copy` / `xclip` / `xsel`（本地）的顺序找工具（连 win32yank 的软链都自己 resolve），旧配置里手写的那段 win32yank 字典纯属多余，已删。
- **SSH 远程**：唯一需要帮忙的情况。不用 `g:clipboard` 字典，而是挂一个 `TextYankPost` autocmd 把 yank 的内容编码成 OSC 52 序列，经 ssh 回到**本地**终端再写进本地剪切板。只要环境变量里有 `SSH_CONNECTION` / `SSH_CLIENT` / `SSH_TTY` 就启用。
  - `TextYankPost` 只覆盖操作符 yank（`y`/`d`/`x`/…）；用 `vim.fn.setreg()` 直接写寄存器的路径不会触发它，必须自己调 `require("utils.clipboard").yank()`（例如 `<leader>l` 复制完整路径）。
- `'clipboard'` 固定 `unnamedplus`。

OSC 52 默认**只写不读**：很多终端允许程序写剪切板但拒绝读（安全考虑），Neovim 内置的 OSC 52 paste 会阻塞等待终端响应，所以 `"+p` 默认不可用 —— 粘贴用终端自身的按键（Ctrl+Shift+V / 中键）；真想要就设 `vim.g.clipboard_osc52_paste = true`。实测一次 `yy` 只发一条 OSC 52 序列（`52;c;`），payload 正确。

> 远程 + tmux：需要在 tmux 里 `set -g set-clipboard on`，OSC 52 才能透传到本地终端。

**已知坑：WSL interop 掉了 → 所有 `.exe` 不能执行。** Windows 的 `.exe` 在 WSL 里靠 `binfmt_misc` 的 `WSLInterop` 记录执行；这条记录一旦没有，`win32yank.exe`（以及 `clip.exe`、`cmd.exe`…）全部报 `cannot execute binary file`，跟文件在不在、是否可执行、用不用绝对路径都无关。在 systemd 发行版（Arch）上，systemd 挂载 `binfmt_misc` 会清掉 WSL 启动时注册的那条记录，而 `systemd-binfmt.service` 又因 `binfmt.d` 目录全空被条件跳过。永久修法（借 WSL 自己生成的 override）：

```sh
sudo mkdir -p /etc/binfmt.d
printf ':WSLInterop:M::MZ::/init:P\n' | sudo tee /etc/binfmt.d/wsl-interop.conf
sudo systemctl start systemd-binfmt   # 目录非空后，之后每次开机 sysinit 自动执行
```

临时修法：`sudo sh -c 'echo ":WSLInterop:M::MZ::/init:P" > /proc/sys/fs/binfmt_misc/register'`，或在 Windows 侧 `wsl --shutdown` 重启实例。配置层不再为这个坑兜底 —— 修好系统后 Neovim 自动探测即可。

---

## 3. 分类原则（重要）

1. **按"领域/用途"分组，不按"像素画在哪"。**
   例：gitsigns 画在 sign column，但归 `git/` 而不是 `ui/`。
2. **两条轴分开用、各自清楚**：功能域（ui/editor/nav/git/code/build）+ 文件类型（`ft/`）。
3. **文件类型插件放 `modules/ft/<lang>/`；纯 buffer 选项放 `after/ftplugin/`。**
4. **一个模块 = 一个可独立开关的功能域。** 单插件的小功能并入最近的域（outline 并进 nav）；同类插件 ≥2 个才值得独立成域。
5. **依赖尽量不跨模块指向**：picker 属于 `snacks` 引擎，但使用它的键位写在各功能域的 `keys.lua`。

---

## 4. 归属决定

| 决定 | 说明 |
|---|---|
| **删除** tex / dap / hex / ipynb | 用不上。连带删除 `configs/tex.lua`、`configs/dap.lua`、`configs/hex.lua`、`configs/ipynb.lua`，以及 lsp 里的 `texlab` |
| **删除** nvim-surround / nvim-scrollview | 早已注释掉的死代码 |
| **删除** lazygit | 花里胡哨，用不上 |
| **删除** snacks.terminal | 终端走 toggleterm，冗余 |
| **删除** mason-lspconfig.nvim | 声明了但从未 `setup()`，纯死插件 |
| **删除** tokyonight / onenord | 主题只用 onedark（白天 light / 夜晚 warmer；edge 作为备选装着） |
| **ui + window 合并** | 窗口布局是 UI 的一部分 |
| **git 独立成模块** | 从 `ui` 里拆出 gitsigns / git-conflict |
| **editor 定义** | "和 LSP 无关、和 UI 无关的编辑优化"；因此 hlslens（检索）移到 `nav` |
| **lsp / completion / format 挂 `code/` 下但不合并** | 强相关、有真实依赖（lsp_config 用 `blink.get_lsp_capabilities`），但保持各自文件 |
| **snacks 只当引擎** | 只留 spec + setup；键位分派到 nav / git / code.lsp |
| **haunt.nvim 归 nav，前缀 `<leader>n`** | 它是"个人笔记/跳转"，虚拟文本只是渲染方式（同 gitsigns 的道理） |
| **treesitter 独立成模块** | 它是唯一需要 git + C 编译器的模块，隔离便于离线处理 |
| **保留 snacks，不换 mini** | 见 §9 |
| **清理 mason 里未使用的包** | 删除 clangd（改用 clice；**但 clangd 的 LSP 配置以注释形式保留**，clice 不成熟、随时可切回）、codelldb（dap 已删）、jedi-language-server（改用 ty）、ruff、shfmt、texlab（tex 已删），释放约 492 MB；并移除 cmake 里引用 codelldb 的 `cmake_dap_configuration` 与 `<leader>Cd` |
| **替换 nvim_winpick** | 编译好的 Rust 二进制在 Neovim 0.12 上 segfault（按 `<leader>fw` 直接崩 nvim）；删掉插件，`<leader>fw` 改为纯 Lua 的窗口标签选择器（在每个窗口左上角浮出一个 3×3 的标签徽标，按对应键聚焦；尺寸可在 `ui/keys.lua` 的 `label_w`/`label_h` 调） |

被否决/搁置的方案：整体迁移到 mini.nvim（原因见 §9）。

---

## 5. 修掉的老 bug

| 老问题 | 现状 |
|---|---|
| `Comment.nvim` 从未被 `setup()`（`comment_config` 返回的表被 `with_config_and_keys` 丢弃） | 用 `opts = require("modules.editor.config").comment` 正确传入 |
| neo-tree 自定义 `window.mappings` 从未生效（返回值被丢） | 直接写进 `require("neo-tree").setup({ window = { mappings = ... } })` |
| `join()` 的 `ipairs` 在 `nil` 处停止，静默丢弃后续插件（hex 整组） | loader 改为遍历显式 `order` |
| `with_config_and_keys` 函数名拼错静默跳过 | 直接 `require`，失败即报错 |
| `Map.*` 只接受 `(lhs, rhs, desc, opts)`，用 `vim.keymap.set` 风格把 opts 表当第 3 个参数传会崩（旧 `smark_keymaps` 因从未被接线而一直潜伏） | `utils/map.lua` 现在两种写法都支持 |

---

## 6. UI / 交互细节决策

| 项 | 决定 |
|---|---|
| 主题 | `sunset.nvim` 按时间切换：白天 `onedark` 的 `light` 变体，夜晚 `onedark`（warmer）。之前白天用 `edge`，2026-09-22 换成 onedark light（插件高亮覆盖更全；edge 仍装着，随时可切回）。两个回调都必须走 `require("onedark").setup({ style = ... })`，直接赋值 `require("onedark").style` 是空操作，而且只要配置里的 style 还是 `light`，`:colorscheme onedark` 会一直保持浅色 |
| 状态栏 | `lualine`（底部，`laststatus=3` 全局） |
| tabline | `barbar`（顶部，buffer 标签） |
| winbar | `dropbar`（每个窗口顶部的面包屑） |
| 滚动条 | `nvim-scrollbar`（右侧竖条） |
| **诊断显示** | `underline = true`（标出问题范围）、`virtual_text = false`、`virtual_lines = false`、`signs = true`；`<leader>d` 浮动窗看全文，`<leader>t` trouble 看全项目 |
| **cursorline** | 启用 `nvim-cursorline` 的 `cursorline`（延迟 50ms，移动时不亮，停下才点亮）；`cursorword` 关闭（到处下划线，阅读不友好） |
| **浮窗边框** | **全部无边框**：`winborder = ""`；`snacks.input` 与诊断浮窗显式 `border = "none"`。注意 `snacks.input` 默认 `border = true`，在 `winborder` 为空时会**回退成 `"rounded"`**，而浮窗背景是直角方块 → 出现"圆角线框套在直角方块里"的难看效果。现在的处理是全部不要边框 |
| picker 分隔线 | snacks `ivy` 布局自带的 顶线 / input 下横线 / list-preview 竖线 **保留**（它们是布局分隔，不是窗口边框） |

---

## 7. 性能

启动耗时实测（headless `--startuptime`，取稳定值）：

| 阶段 | 启动 |
|---|---|
| 重构前（旧配置） | ~269 ms |
| 移除 eager 的 cmake-tools 之后 | ~67 ms |
| 再移除 LuaSnip 之后 | **~59–64 ms** |

主要优化：

- **cmake-tools 改为 `cmd` 懒加载**（原本 `lazy=false` 却带了 `cmd` 列表，`cmd` 完全失效），省下最大一块。
- **删除 tokyonight / onenord**（`:colorscheme` 仍可用 edge/onedark）。
- **删除 LuaSnip**。查证 blink.cmp 的 `snippets` **default** preset 会直接从 runtimepath 读取 `friendly-snippets` 并用内置 `vim.snippet` 展开，LuaSnip 纯冗余。删掉后片段照常工作（lua 24 / c 73 / cpp 42 / python 67 / markdown 71 条），并**去掉 `make install_jsregexp` 这个需要 make + C 编译器的构建步骤**。
- 当前：**42 个插件，0 错误**。

> 注意：旧配置的 `snippets.expand` 指向 LuaSnip，而 `active`/`jump` 仍是 `vim.snippet`（不一致）；现在统一为内置实现。补全**列表项内容不变**（两边都是 default provider）。

---

## 8. 离线 / 无 sudo 服务器部署

前提假设：目标机**无外网、无 sudo**，架构 `x86_64-linux`。

### 8.1 必须打包的东西（实测体积）

| 内容 | 路径 | 体积 |
|---|---|---|
| 配置 | `~/.config/nvim` | < 1 MB |
| 插件（含 blink 的 Rust `.so`、LuaSnip 遗留目录） | `~/.local/share/nvim/lazy` | 190 MB |
| mason 下载的 LSP/格式化器（10 个） | `~/.local/share/nvim/mason` | 278 MB |
| 编译好的 treesitter parser | `~/.local/share/nvim/site` | 17 MB |
| lazy/shada/undo 状态 | `~/.local/state/nvim` | 80 MB |
| Neovim 本身 | 需 **≥ 0.11**（配置用 `vim.lsp.config`/`vim.lsp.enable`；treesitter-manager 需 0.12） | — |
| CLI 工具 | `rg`（snacks grep 硬依赖）、`fd`、`fzf`、`lazygit`（已不再需要） | 静态单文件 |
| 全局格式化配置 | `formatters/.config/{stylua,yapf}`、`formatters/.clang-format/` | — |

合计约 **570 MB**。

### 8.2 可重定位打包（方案 A：功能完整）

- **不要拷 `/usr/bin/nvim`**（动态链接系统库），用官方 release tarball。
- 用 XDG 环境变量把整包变成自包含目录，与 `$HOME` 解耦。
- 配置里没有 `/home/xt` 硬编码；lazy 状态里只有 `pkg-cache.lua` 含绝对路径（删掉即重建）。

wrapper 脚本思路：

```sh
#!/bin/sh
B="$(cd "$(dirname "$0")" && pwd)"
export XDG_CONFIG_HOME="$B/config"
export XDG_DATA_HOME="$B/data"
export XDG_STATE_HOME="$B/state"
export PATH="$B/bin:$B/nvim-linux-x86_64/bin:$PATH"
exec "$B/nvim-linux-x86_64/bin/nvim" "$@"
```

注意：arch 必须一致；nvim 官方 tarball 需要较新 glibc（老系统可能跑不起来）。

### 8.3 server profile（方案 B：精简）

同一份配置用条件 `import`/`enabled` 关掉重件（mason / tree-sitter-manager / 重型 UI），LSP 二进制手动放到 PATH，parser 预置。tarball 可降到 ~200 MB，不需要编译器和网络。

### 8.4 离线正确性唯一遗留 ⚠️

`modules/treesitter/config.lua` 的 `ensure_installed` 会在 `setup()` 时尝试安装缺失 parser（需 **git + gcc + 网络**）。**尚未加开关。** 计划：

```lua
local server = vim.env.NVIM_SERVER ~= nil
require("tree-sitter-manager").setup({
    ensure_installed = server and {} or { "c", "cpp", "python", "bash", "html", "lua", "markdown", "markdown_inline" },
    highlight = true,
})
```

只要把 `~/.local/share/nvim/site/parser` 一起打包，`ensure_installed` 会发现都已存在，不会触发安装。`auto_install` 默认已是 `false`。

---

## 9. 关于 snacks / mini 的评估结论（为什么留 snacks）

用户偏好：**纯 Lua、无三方运行时依赖的插件**；只有带来明显速度/能力收益时才接受外部依赖。

实测结论：

- **snacks.nvim 是纯 Lua，无编译组件，无外层依赖。** 唯一硬依赖是 `rg`（grep picker 硬编码）；files picker 会自动探测 `fd`/`rg`/`find`；模糊匹配是自研 Lua 引擎，**不需要 fzf 二进制**。
- 维护现状（截至 2026-09-16）：最后提交 2026-05-25、最后发版 v2.31.0（2026-03-20）；2025 年 10–11 月有一次约 600 commit 的大爆发后进入维护态；作者 folke 近期在做 `zaly` / `sidekick.nvim`。属于"做完进维护态"，不是弃坑。
- **想替代它的插件大多更旧**：toggleterm（2025-03）、nvim-notify（2025-09）、noice（2025-11）、lazygit.nvim（2025-12）。
- **mini.nvim** 是唯一全面更活跃的替代（纯 Lua、零依赖、模块化、已迁到 nvim-mini 组织），但：无 terminal 模块、无 lazygit、`mini.pick` 比 `snacks.picker` 朴素得多，且 **haunt.nvim 的 picker 集成不支持 `mini.pick`**（支持 snacks/telescope/fzf-lua）。
- **结论：保留 snacks**，把它当"引擎"，键位分派到各功能域，未来要换也只动一个模块。

---

## 10. 待办 / 备忘

- [x] **git 已接好**。重构经 PR #1 合入 `master`，`remake` 分支已删；日常直接在 `master` 上提交推送。
- [ ] **treesitter 离线门**（§8.4）。
- [ ] **`Lazy clean`** 清掉遗留的 LuaSnip 目录（已从 spec 移除）。
- [ ] （可选）picker 是否改用 mini.pick —— 需先接受 `haunt.nvim` 的 picker 集成失效。
- [ ] （可选）用 `mini.nvim` 的模块替换一批单体小插件（comment/pairs/icons/statusline/indentscope/cursorword/diff…），提升维护新鲜度。

---

## 11. 维护须知

- **改插件**：编辑对应模块的 `spec.lua` / `config.lua`；键位在 `keys.lua`（启动时注册）。
- **加功能域**：新建 `lua/modules/<name>/{spec,config,keys}.lua`，并在 `lua/modules/init.lua` 的 `order` 里加一行。
- **加文件类型支持**：插件放 `modules/ft/<lang>/`；纯 buffer 选项放 `after/ftplugin/<ft>.lua`。
- **验证方式**（headless 冒烟测试）：

  ```sh
  nvim --headless -u init.lua \
    -c 'lua local l=require("lazy"); local n,e=0,0; for _,p in ipairs(l.plugins()) do n=n+1; if p._ and p._.error then e=e+1; print(p.name, p._.error) end end; print("plugins="..n.." errors="..e)' \
    -c 'qa!'
  ```

- 旧配置随时可以对照：`XDG_CONFIG_HOME` 指向一个含 `nvim -> ~/.config/nvim-old` 软链的临时目录即可实跑旧配置做 A/B 对比。
