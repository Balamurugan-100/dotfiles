--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------

local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Search Highlight" })

-- Save
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save File" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write Buffer" })

-- Quit
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit Window" })
map("n", "<leader>x", "<cmd>wq<CR>", { desc = "Save & Quit" })

--------------------------------------------------------------------------------
-- Resize Windows
--------------------------------------------------------------------------------

map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase Height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase Width" })

--------------------------------------------------------------------------------
-- Buffers
--------------------------------------------------------------------------------

map("n", "<S-h>", "<cmd>bprevious<CR>", {
    desc = "Previous Buffer",
    silent = true,
})

map("n", "<S-l>", "<cmd>bnext<CR>", {
    desc = "Next Buffer",
    silent = true,
})

map("n", "<leader>bb", "<cmd>buffer#<CR>", {
    desc = "Previous Buffer",
})

map("n", "<leader>bd", "<cmd>bdelete<CR>", {
    desc = "Delete Buffer",
})

map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", {
    desc = "Delete Other Buffers",
})

--------------------------------------------------------------------------------
-- Diagnostics
--------------------------------------------------------------------------------

vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,

    float = {
        border = "rounded",
        source = "if_many",
    },

    underline = {
        severity = {
            min = vim.diagnostic.severity.WARN,
        },
    },

    virtual_text = true,
    virtual_lines = false,
})

map("n", "[d", vim.diagnostic.goto_prev, {
    desc = "Previous Diagnostic",
})

map("n", "]d", vim.diagnostic.goto_next, {
    desc = "Next Diagnostic",
})

map("n", "<leader>e", vim.diagnostic.open_float, {
    desc = "Line Diagnostics",
})

map("n", "<leader>dq", vim.diagnostic.setloclist, {
    desc = "Diagnostics List",
})

--------------------------------------------------------------------------------
-- Terminal
--------------------------------------------------------------------------------

map("t", "<Esc><Esc>", "<C-\\><C-n>", {
    desc = "Exit Terminal Mode",
})

--------------------------------------------------------------------------------
-- Move Lines
--------------------------------------------------------------------------------

map("n", "<A-j>", "<cmd>m .+1<CR>==", {
    desc = "Move Line Down",
})

map("n", "<A-k>", "<cmd>m .-2<CR>==", {
    desc = "Move Line Up",
})

map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", {
    desc = "Move Line Down",
})

map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", {
    desc = "Move Line Up",
})

map("v", "<A-j>", ":m '>+1<CR>gv=gv", {
    desc = "Move Selection Down",
})

map("v", "<A-k>", ":m '<-2<CR>gv=gv", {
    desc = "Move Selection Up",
})

--------------------------------------------------------------------------------
-- Quickfix
--------------------------------------------------------------------------------

map("n", "]q", "<cmd>cnext<CR>", {
    desc = "Next Quickfix",
})

map("n", "[q", "<cmd>cprev<CR>", {
    desc = "Previous Quickfix",
})

map("n", "]l", "<cmd>lnext<CR>", {
    desc = "Next Location",
})

map("n", "[l", "<cmd>lprev<CR>", {
    desc = "Previous Location",
})


-- Terminal
--

-- Open terminal (bottom/right/float splits are mapped in custom.plugins.snacks)

-- Exit terminal mode
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal Normal Mode" })

-- Window navigation from terminal
map("t", "<C-h>", [[<C-\><C-n><C-w>h]])
map("t", "<C-j>", [[<C-\><C-n><C-w>j]])
map("t", "<C-k>", [[<C-\><C-n><C-w>k]])
map("t", "<C-l>", [[<C-\><C-n><C-w>l]])

-- Close terminal
map("t", "<leader>q", [[<C-\><C-n><cmd>close<CR>]], { desc = "Close Terminal" })
