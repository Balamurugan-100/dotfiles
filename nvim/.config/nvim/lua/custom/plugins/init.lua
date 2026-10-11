--------------------------------------------------------------------------------
-- Plugin Registry
--
-- All vim.pack.add() calls are centralized here.
-- Individual files only contain configuration.
--------------------------------------------------------------------------------

local function gh(repo)
  return "https://github.com/" .. repo
end

--------------------------------------------------------------------------------
-- Install
--------------------------------------------------------------------------------

vim.pack.add({
  -- Colorscheme
  gh("folke/tokyonight.nvim"),
  gh("folke/todo-comments.nvim"),
  gh("nvim-lua/plenary.nvim"), -- todo-comments dependency

  -- Completion
  { src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") },
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },

  -- Debug
  gh("mfussenegger/nvim-dap"),
  gh("rcarriga/nvim-dap-ui"),
  gh("nvim-neotest/nvim-nio"),
  gh("jay-babu/mason-nvim-dap.nvim"),
  gh("leoluz/nvim-dap-go"),

  -- Formatting
  gh("mfussenegger/nvim-lint"),

  -- Git
  gh("lewis6991/gitsigns.nvim"),

  -- LSP
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  gh("j-hui/fidget.nvim"),

  -- Statusline
  gh("nvim-lualine/lualine.nvim"),

  -- Fuzzy Finder
  gh("nvim-telescope/telescope.nvim"),
  gh("nvim-telescope/telescope-ui-select.nvim"),

  -- UI
  gh("folke/snacks.nvim"),
  gh("folke/trouble.nvim"),
  gh("folke/noice.nvim"),
  gh("MunifTanjim/nui.nvim"),
  gh("akinsho/bufferline.nvim"),

  -- Mini
  gh("nvim-mini/mini.nvim"),

  -- Session
  gh("folke/persistence.nvim"),

  -- Tmux
  gh("christoomey/vim-tmux-navigator"),

  -- Keymap Hints
  gh("folke/which-key.nvim"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("nvim-mini/mini.nvim"),
  gh("MeanderingProgrammer/render-markdown.nvim")
})

if vim.fn.executable("make") == 1 then
  vim.pack.add({ gh("nvim-telescope/telescope-fzf-native.nvim") })
end

require("custom.plugins.colorscheme")
require("custom.plugins.bufferline")
require("custom.plugins.completion")
require("custom.plugins.completion")
require("custom.plugins.debug")
require("custom.plugins.formatting")
require("custom.plugins.gitsigns")
require("custom.plugins.lsp")
require("custom.plugins.lualine")
require("custom.plugins.mini")
require("custom.plugins.noice")
require("custom.plugins.persistence")
require("custom.plugins.telescope")
require("custom.plugins.snacks")
require("custom.plugins.tmux")
require("custom.plugins.ui")
require("custom.plugins.which-key")
