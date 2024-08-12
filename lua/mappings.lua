require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map({ "n", "v" }, "<C-s>", ":wa <cr>", { desc = "Quick save all" })

map("n", "<C-z>", "u", { desc = "Undo" })
map("n", "<F4>", ":%s/<c-r><c-w>/<c-r><c-w>/gc<c-f>$F/i", { desc = "Replace word under cursor" })
map("n", "<leader>fg", "<cmd>Telescope grep_string<CR>", { desc = "Grep string" })

map("i", "<C-s>", "<ESC>:wa<cr>", { desc = "Quick save all" })
map("i", "<C-v>", "<ESC>pa", { desc = "Paste from clipboard" })
-- C-z Undo
map("i", "<C-z>", "<ESC>ua", { desc = "Undo" })
-- -- Ctrl-Shift- right arrow to select word
map("i", "<C-S-Right>", "<ESC>vaw", { desc = "Select word" })

-- Visual mode
-- C-x to Cut to clipboard
map("v", "<C-x>", "x", { desc = "Cut to clipboard" })
map("v", "<C-z>", "<ESC>ua", { desc = "Undo" })

-- <ESC> to exit terminal mode
map("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
