--------------------------------------------------------------------------------
-- telescope.nvim — finders & LSP navigation
--------------------------------------------------------------------------------

local trouble_telescope = require("trouble.sources.telescope")

require("telescope").setup({
  defaults = {
    -- <C-t> inside any picker sends the results to trouble.nvim
    mappings = {
      i = { ["<C-t>"] = trouble_telescope.open },
      n = { ["<C-t>"] = trouble_telescope.open },
    },
  },
  extensions = {
    ["ui-select"] = require("telescope.themes").get_dropdown(),
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")

-- Search
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })

vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })

vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })

vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Picker" })

vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })

vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })

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
  builtin.live_grep({
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
