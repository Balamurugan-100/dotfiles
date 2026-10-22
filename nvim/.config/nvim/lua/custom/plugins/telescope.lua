--------------------------------------------------------------------------------
-- telescope.nvim — finders & LSP navigation
--------------------------------------------------------------------------------

local trouble_telescope = require("trouble.sources.telescope")

-- File pickers list dotfiles and gitignored files by default.
-- <C-h> toggles hidden files, <C-g> toggles gitignored files inside a picker.
local file_flags = { hidden = true, ignored = true }

-- ripgrep/fd argument that opts into gitignored files
local function no_ignore_args()
  return file_flags.ignored and { "--no-ignore" } or {}
end

-- Rebuilds the running picker after a flag toggle. Set by the wrapped
-- pickers below; for pickers opened directly from telescope.builtin the
-- flags just apply to the next picker that is opened.
local reopen

local function toggle_flag(flag, desc)
  return function(prompt_bufnr)
    file_flags[flag] = not file_flags[flag]
    local rebuild = reopen
    if rebuild then
      require("telescope.actions").close(prompt_bufnr)
      rebuild()
    end
    vim.notify(("%s: %s"):format(desc, file_flags[flag] and "shown" or "hidden"))
  end
end

require("telescope").setup({
  defaults = {
    -- baseline for every picker, kept in sync with `file_flags` by the
    -- wrapped pickers below
    hidden = true,
    no_ignore = true,
    additional_args = no_ignore_args,
    -- <C-t> inside any picker sends the results to trouble.nvim
    -- <C-h>/<C-g> toggle hidden / gitignored files
    mappings = {
      i = {
        ["<C-t>"] = trouble_telescope.open,
        ["<C-h>"] = toggle_flag("hidden", "Hidden files"),
        ["<C-g>"] = toggle_flag("ignored", "Gitignored files"),
      },
      n = {
        ["<C-t>"] = trouble_telescope.open,
        ["<C-h>"] = toggle_flag("hidden", "Hidden files"),
        ["<C-g>"] = toggle_flag("ignored", "Gitignored files"),
      },
    },
  },
  extensions = {
    ["ui-select"] = require("telescope.themes").get_dropdown(),
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")

-- Wrapped pickers honor the current hidden/ignored flags and remember how
-- to reopen themselves so <C-h>/<C-g> can rebuild the running picker.
local function wrap(picker)
  return function(opts)
    reopen = function()
      picker(opts)
    end
    picker(opts)
  end
end

local find_files = wrap(function(opts)
  builtin.find_files(vim.tbl_extend("force", {
    hidden = file_flags.hidden,
    no_ignore = file_flags.ignored,
  }, opts or {}))
end)

local live_grep = wrap(function(opts)
  builtin.live_grep(vim.tbl_extend("force", {
    hidden = file_flags.hidden,
    additional_args = no_ignore_args,
  }, opts or {}))
end)

local grep_string = wrap(function(opts)
  builtin.grep_string(vim.tbl_extend("force", {
    hidden = file_flags.hidden,
    additional_args = no_ignore_args,
  }, opts or {}))
end)

-- Search
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })

vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })

vim.keymap.set("n", "<leader>sf", find_files, { desc = "[S]earch [F]iles" })

vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Picker" })

vim.keymap.set({ "n", "v" }, "<leader>sw", grep_string, { desc = "[S]earch current [W]ord" })

vim.keymap.set("n", "<leader>sg", live_grep, { desc = "[S]earch by [G]rep" })

vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })

vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })

vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })

vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })

vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "[S]earch [B]uffer Lines" })

-- Current buffer
vim.keymap.set("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "Search Current Buffer" })

-- Grep open files
vim.keymap.set("n", "<leader>s/", function()
  live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "Search Open Files" })

-- Neovim config
vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files({
    cwd = vim.fn.stdpath("config"),
    follow = true,
    hidden = true,
  })
end, { desc = "Search Neovim Config" })

-- Buffers
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find Buffers" })

-- Git
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })

vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })

vim.keymap.set("n", "<leader>gl", builtin.git_commits, { desc = "Git Log" })

vim.keymap.set("n", "<leader>gf", builtin.git_bcommits, { desc = "Git Log File" })

-- Pickers telescope has no equivalent for — kept on snacks.picker
vim.keymap.set("n", "<leader>su", function()
  Snacks.picker.undo()
end, { desc = "[S]earch [U]ndo History" })

vim.keymap.set("n", "<leader>sj", function()
  Snacks.picker.jumps()
end, { desc = "[S]earch [J]umps" })

vim.keymap.set("n", "<leader>gd", function()
  Snacks.picker.git_diff()
end, { desc = "Git Diff (Hunks)" })

-- LSP pickers
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("telescope-lsp", { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }

    local function map(lhs, fn, desc)
      vim.keymap.set("n", lhs, fn, vim.tbl_extend("force", opts, { desc = desc }))
    end

    map("grr", builtin.lsp_references, "References")

    map("grd", builtin.lsp_definitions, "Definition")

    map("gri", builtin.lsp_implementations, "Implementation")

    map("grt", builtin.lsp_type_definitions, "Type Definition")

    map("gO", builtin.lsp_document_symbols, "Document Symbols")

    map("gW", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")
  end,
})

-- Exported so other configs (e.g. the snacks dashboard) open pickers through
-- the same hidden/ignored-aware wrappers
return {
  find_files = find_files,
  live_grep = live_grep,
  grep_string = grep_string,
}
