return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  keys = {
    -- Core
    { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
    { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },

    -- Find
    { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Find Buffers" },
    { "<leader>fc", "<cmd>Telescope find_files cwd=~/.config/nvim<cr>", desc = "Find Config Files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word under Cursor" },

    -- Git
    { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git Branches" },
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },

    -- Search
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Search Auto Commands" },
    { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Search Document Diagnostics" },
    { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Search Workspace Diagnostics" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search Help Pages" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Search Jumplist" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search Keymaps" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Search Marks" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Search Options" },
    { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Search Quickfix List" },
    { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Search Location List" },
    { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Search Registers" },
    { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Search Document Symbols" },
    { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Search Workspace Symbols" },
  },
  opts = function()
    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
      },
    }
  end,
}
