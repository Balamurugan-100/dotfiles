local map = vim.keymap.set

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })



map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

map("v", "<", "<gv")
map("v", ">", ">gv")

-- Save & Quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write Buffer" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit Window" })
map("n", "<leader>x", "<cmd>wq<CR>", { desc = "Save & Quit" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous Buffer", silent = true })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next Buffer", silent = true })
map("n", "<leader>bb", "<cmd>buffer#<CR>", { desc = "Previous Buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Delete Other Buffers" })

-- Git
map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Git Blame Toggle" })
map("n", "<leader>gs", "<cmd>Gitsigns<cr>", { desc = "Git Signs" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Git Diff This" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Git Preview Hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Git Reset Hunk" })
map("n", "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Git Stage Hunk" })
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Git Unstage Hunk" })
map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Git Reset Buffer" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" }) -- Changed from <leader>e to avoid conflict with explorer
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics List" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move Line Up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move Line Down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move Line Up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })

-- Quickfix / Location
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next Quickfix" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous Quickfix" })
map("n", "]l", "<cmd>lnext<CR>", { desc = "Next Location" })
map("n", "[l", "<cmd>lprev<CR>", { desc = "Previous Location" })

-- Terminal
map("n", "<leader>th", "<cmd>split | terminal<CR>", { desc = "Terminal (Horizontal)" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Terminal (Vertical)" })
map("n", "<leader>tf", "<cmd>tabnew | terminal<CR>", { desc = "Terminal (Fullscreen)" })
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal Normal Mode" })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]])
map("t", "<C-j>", [[<C-\><C-n><C-w>j]])
map("t", "<C-k>", [[<C-\><C-n><C-w>k]])
map("t", "<C-l>", [[<C-\><C-n><C-w>l]])

-- ============================================================================
-- The "Best" Legendary Vim Remaps
-- ============================================================================

-- Center cursor when moving page down/up
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down (Center)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up (Center)" })

-- Keep cursor centered during search jumping
map("n", "n", "nzzzv", { desc = "Next Search Result" })
map("n", "N", "Nzzzv", { desc = "Prev Search Result" })

-- Keep cursor in place when joining lines
map("n", "J", "mzJ`z", { desc = "Join Lines (Keep Cursor)" })

-- Yank to system clipboard (so you can paste outside nvim)
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to System Clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank Line to System Clipboard" })

-- Paste over highlighted text without losing your yanked text! (The Void Register)
map("x", "<leader>p", '"_dP', { desc = "Paste Over (Keep Yanked)" })

-- Delete into the void register (so it doesn't overwrite your yank)
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to Void Register" })

-- Consistent Yank to end of line
map("n", "Y", "y$", { desc = "Yank to end of line" })

-- Better Indentation in visual mode (keeps the text selected)
map("v", "<", "<gv", { desc = "Indent Left" })
map("v", ">", ">gv", { desc = "Indent Right" })
