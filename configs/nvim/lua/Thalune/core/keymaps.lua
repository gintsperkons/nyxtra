local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

--vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc= "moves lines down in visual selection"})
--vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc= "moves lines up in visual selection"})

local M = {}

M.lazygit = {
  { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
}

M.neo_tree = {
  { "<C-e>", "<cmd>Neotree filesystem toggle right<cr>", desc = "Toggle Neo-tree (normal)", mode = "n" },
}

return M
