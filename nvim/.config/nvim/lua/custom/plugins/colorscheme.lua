require('catppuccin').setup {
  flavour = 'mocha',
  transparent_background = true,
  term_colors = true,
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { 'undercurl' },
        hints = { 'undercurl' },
        warnings = { 'undercurl' },
        information = { 'undercurl' },
      },
    },
    telescope = {
      enabled = true,
    },
    which_key = true,
    gitsigns = true,
    mini = true,
  },
}

vim.cmd.colorscheme 'catppuccin'

require('todo-comments').setup {
  signs = false,
}
