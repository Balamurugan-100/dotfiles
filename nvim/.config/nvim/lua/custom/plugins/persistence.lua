require("persistence").setup({
  dir = vim.fn.stdpath("state") .. "/sessions/",
  need = 1,
  branch = true,
})

-- Session ---------------------------------------------------------------------

local persistence = require("persistence")

vim.keymap.set("n", "<leader>Sr", function()
  persistence.load()
end, {
  desc = "Session Restore",
})

vim.keymap.set("n", "<leader>Sl", function()
  persistence.load({ last = true })
end, {
  desc = "Session Restore Last",
})

vim.keymap.set("n", "<leader>Ss", function()
  persistence.save()
end, {
  desc = "Session Save",
})

vim.keymap.set("n", "<leader>Sd", function()
  persistence.stop()
end, {
  desc = "Session Disable",
})
