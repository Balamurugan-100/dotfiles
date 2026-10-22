--------------------------------------------------------------------------------
-- snacks.nvim — explorer, picker, notifications, indent, input, dashboard…
--------------------------------------------------------------------------------

-- Dashboard header art.
-- Snacks center-aligns every line individually, so all lines need the same
-- width or the picture falls apart. Pad them to the widest line below.
local header = [[
 █████   ████            ███
░░███   ███░            ░░░
 ░███  ███     ██████   ████   █████████  ██████  ████████
 ░███████     ░░░░░███ ░░███  ░█░░░░███  ███░░███░░███░░███
 ░███░░███     ███████  ░███  ░   ███░  ░███████  ░███ ░███
 ░███ ░░███   ███░░███  ░███    ███░   █░███░░░   ░███ ░███
 █████ ░░████░░████████ █████  █████████░░██████  ████ █████
░░░░░   ░░░░  ░░░░░░░░ ░░░░░  ░░░░░░░░░  ░░░░░░  ░░░░ ░░░░░
]]

do
  header = header:gsub("\n$", "")
  local lines = vim.split(header, "\n", { plain = true })
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.api.nvim_strwidth(line))
  end
  for i, line in ipairs(lines) do
    lines[i] = line .. (" "):rep(width - vim.api.nvim_strwidth(line))
  end
  header = table.concat(lines, "\n")
end

require("snacks").setup({
  bigfile = { enabled = true },

  dashboard = {
    enabled = true,
    -- Drop the default `startup` section: it calls `require("lazy.stats")`,
    -- which doesn't exist since this config uses vim.pack, not lazy.nvim.
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
    -- Send the dashboard's Find File / Find Text / Recent Files keys to telescope
    preset = {
      header = header,
      pick = function(cmd, opts)
        local map = { files = "find_files", live_grep = "live_grep", oldfiles = "oldfiles" }
        local name = map[cmd] or cmd
        -- go through custom.plugins.telescope's wrappers so the hidden/ignored
        -- defaults (and <C-h>/<C-g> toggles) apply here too
        local picker = require("custom.plugins.telescope")[name] or require("telescope.builtin")[name]
        if picker then
          picker(opts)
        end
      end,
    },
  },
  dim = { enabled = true },
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },

  notifier = {
    enabled = true,
    timeout = 3000,
  },

  picker = {
    -- <C-t> inside any picker sends the results to trouble.nvim
    actions = require("trouble.sources.snacks").actions,
    win = {
      input = {
        keys = {
          ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
        },
      },
    },
    sources = {
      explorer = {
        -- always list dotfiles and gitignored files
        hidden = true,
        ignored = true,
        -- \ closes the explorer (same as the old neo-tree mapping)
        -- <C-h>/<C-g> toggle hidden / gitignored files (same keys as telescope)
        win = {
          input = {
            keys = {
              ["\\"] = "close",
              ["<c-h>"] = { "toggle_hidden", mode = { "n", "i" } },
              ["<c-g>"] = { "toggle_ignored", mode = { "n", "i" } },
            },
          },
          list = {
            keys = {
              ["\\"] = "close",
              ["<c-h>"] = { "toggle_hidden", mode = { "n", "i" } },
              ["<c-g>"] = { "toggle_ignored", mode = { "n", "i" } },
            },
          },
        },
      },
    },
  },

  quickfile = { enabled = true },

  scope = {
    enabled = true,
    -- protect mini.ai's custom "ii"/"aa" textobjects
    keys = { textobject = { ii = false, ai = false } },
  },

  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  terminal = { enabled = true },
  words = { enabled = true },
})

-- Sessions --------------------------------------------------------------------

-- The dashboard's "Restore Session" key detects plugins through lazy.nvim's
-- `have_plugin`, which is always false with vim.pack — wire it to
-- persistence.nvim directly instead.
local dashboard = require("snacks.dashboard")
dashboard.sections.session = function(item)
  if pcall(require, "persistence") then
    return setmetatable({
      action = ":lua require('persistence').load()",
      section = false,
    }, { __index = item })
  end
end

--------------------------------------------------------------------------------
-- Explorer (replaces neo-tree)
--------------------------------------------------------------------------------

-- Root the tree at the project root (git) first, the current working
-- directory as fallback
local function explorer_root()
  local cwd = vim.fn.getcwd()
  local start = vim.api.nvim_buf_get_name(0)
  start = start ~= "" and start or cwd
  return vim.fs.root(start, { ".git" }) or vim.fs.root(cwd, { ".git" }) or cwd
end

vim.keymap.set("n", "\\", function()
  Snacks.explorer.reveal({ cwd = explorer_root() })
end, { desc = "Explorer: Reveal File", silent = true })

vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer({ cwd = explorer_root() })
end, { desc = "File Explorer", silent = true })

-- Root the tree at the current file's directory instead of the project root
local function explorer_file_dir()
  local name = vim.api.nvim_buf_get_name(0)
  if name ~= "" then
    return vim.fs.dirname(name)
  end
  return explorer_root()
end

vim.keymap.set("n", "<leader>E", function()
  Snacks.explorer({ cwd = explorer_file_dir() })
end, { desc = "File Explorer (file dir)", silent = true })

-- Open the explorer at Neovim's current working directory, regardless of
-- where the current file lives
vim.keymap.set("n", "<leader>ec", function()
  Snacks.explorer({ cwd = vim.fn.getcwd() })
end, { desc = "File Explorer (cwd)", silent = true })

--------------------------------------------------------------------------------
-- Terminal
--------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>th", function()
  Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } })
end, { desc = "Terminal (Horizontal)" })

vim.keymap.set("n", "<leader>tv", function()
  Snacks.terminal(nil, { win = { position = "right", width = 0.4 } })
end, { desc = "Terminal (Vertical)" })

vim.keymap.set("n", "<leader>tt", function()
  Snacks.terminal(nil, { win = { position = "float" } })
end, { desc = "Terminal (Float)" })

vim.keymap.set("n", "<C-/>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<C-_>", function()
  Snacks.terminal()
end, { desc = "which_key_ignore" })

--------------------------------------------------------------------------------
-- Toggles (icons/colors integrate with which-key)
--------------------------------------------------------------------------------

Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("conceallevel", {
  off = 0,
  on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
  name = "Conceal",
}):map("<leader>uc")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.dim():map("<leader>uD")

--------------------------------------------------------------------------------
-- Notifications
--------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>un", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss All Notifications" })

vim.keymap.set("n", "<leader>n", function()
  Snacks.picker.notifications()
end, { desc = "Notification History" })

--------------------------------------------------------------------------------
-- Git
--------------------------------------------------------------------------------

vim.keymap.set({ "n", "v" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse" })

vim.keymap.set("n", "<leader>gg", function()
  if vim.fn.executable("lazygit") == 1 then
    Snacks.lazygit()
  else
    vim.notify("lazygit is not installed", vim.log.levels.WARN)
  end
end, { desc = "LazyGit" })

--------------------------------------------------------------------------------
-- Files, focus & scratch
--------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>cR", function()
  Snacks.rename.rename_file()
end, { desc = "Rename File" })

vim.keymap.set("n", "<leader>.", function()
  Snacks.scratch()
end, { desc = "Scratch Buffer" })

vim.keymap.set("n", "<leader>z", function()
  Snacks.zen()
end, { desc = "Zen Mode" })

vim.keymap.set("n", "<leader>Z", function()
  Snacks.zen.zoom()
end, { desc = "Zoom" })

--------------------------------------------------------------------------------
-- LSP word references (snacks.words)
--------------------------------------------------------------------------------

vim.keymap.set("n", "]]", function()
  Snacks.words.jump(vim.v.count1)
end, { desc = "Next Reference" })

vim.keymap.set("n", "[[", function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous Reference" })

--------------------------------------------------------------------------------
-- Debug helpers — :lua dd(expr) / bt() for pretty inspect & backtrace
--------------------------------------------------------------------------------

_G.dd = Snacks.debug.inspect
_G.bt = Snacks.debug.backtrace
