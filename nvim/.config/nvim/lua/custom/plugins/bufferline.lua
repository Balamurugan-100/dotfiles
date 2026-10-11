--------------------------------------------------------------------------------
-- bufferline.nvim — buffer tabline, transparent to match the rest of the UI
--------------------------------------------------------------------------------

vim.o.showtabline = 2

require("bufferline").setup({
  options = {
    mode = "buffers",
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    show_close_icon = false,
    separator_style = "thin",
    hover = {
      enabled = true,
      delay = 200,
      reveal = { "close" },
    },
    offsets = {
      { filetype = "snacks_picker_list", text = "Explorer", separator = "right" },
    },
  },

  highlights = {
    fill = { bg = "NONE" },
    background = { bg = "NONE", fg = "#565f89" },
    buffer_visible = { bg = "NONE", fg = "#c8d3f5" },
    buffer_selected = { bg = "NONE", fg = "#c8d3f5", bold = true, italic = false },
    separator = { bg = "NONE" },
    separator_visible = { bg = "NONE" },
    separator_selected = { bg = "NONE" },
    indicator_selected = { fg = "#82aaff" },
    modified = { fg = "#ffc777" },
    modified_visible = { fg = "#ffc777" },
    modified_selected = { fg = "#ffc777" },
  },
})
