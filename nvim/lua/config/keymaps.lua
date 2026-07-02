-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>rn", ":IncRename ")
-- override LazyVim's snacks git_log_file with diffview file history
vim.keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "File History (current file)" })
-- use fff.nvim for find-files instead of the snacks picker
vim.keymap.set("n", "<leader>ff", function() require("fff").find_files() end, { desc = "Find Files (fff)" })
vim.keymap.set("n", "<leader><space>", function() require("fff").find_files() end, { desc = "Find Files (fff)" })
vim.keymap.set("n", "<leader>fF", function() require("fff").find_files_in_dir(vim.uv.cwd()) end, { desc = "Find Files cwd (fff)" })
