--------------------------------------------------------------------------------
-- trouble.nvim — diagnostics, symbols & lists panel
--------------------------------------------------------------------------------

require("trouble").setup({})

vim.keymap.set("n", "<leader>dd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {
  desc = "Trouble: Buffer Diagnostics",
})
vim.keymap.set("n", "<leader>dw", "<cmd>Trouble diagnostics toggle<cr>", {
  desc = "Trouble: Workspace Diagnostics",
})
vim.keymap.set("n", "<leader>ds", "<cmd>Trouble symbols toggle focus=false<cr>", {
  desc = "Trouble: Document Symbols",
})
vim.keymap.set("n", "<leader>dl", "<cmd>Trouble loclist toggle<cr>", {
  desc = "Trouble: Location List",
})
