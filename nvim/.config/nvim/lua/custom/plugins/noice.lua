--------------------------------------------------------------------------------
-- noice.nvim — cmdline, popupmenu, messages, hover & signature help
--------------------------------------------------------------------------------

require("noice").setup({
  views = {
    cmdline_popup = {
      position = {
        row = 4, -- Distance from the top
        col = "50%",
      },
    },
  },

  notify = { enabled = false },

  lsp = {
    progress = { enabled = false },
    hover = { enabled = true },
    signature = { enabled = true },
  },

  cmdline = { view = "cmdline_popup" },
  messages = { enabled = true },
  popupmenu = { enabled = true },
})
