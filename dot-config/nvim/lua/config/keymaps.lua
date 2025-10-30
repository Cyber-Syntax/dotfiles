-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

--lets fix pasted from clipboard is not adding it below on the current line:
map("n", "gp", "<cmd>put<CR>", { silent = true, desc = "Paste after cursor from clipboard" })
map("n", "gP", "<cmd>put!<CR>", { silent = true, desc = "Paste before cursor from clipboard" })

-- alt+h , l to home end behavior
map("n", "<A-l>", "$", { desc = "Move to end of line" })
map("n", "<A-h>", "^", { desc = "Move to start of line" })
map("v", "<A-h>", "^", { desc = "Move to start of line" })
map("v", "<A-l>", "$", { desc = "Move to end of line" })
map("o", "<A-h>", "^", { desc = "Move to start of line" })
map("o", "<A-l>", "$", { desc = "Move to end of line" })

map("n", "<C-z>", "<nop>", { desc = "Disable suspend" })

-- octo.nvim pr create keymap
map("n", "<leader>gC", "<cmd>Octo pr create<cr>", { desc = "Create PR" })
map("n", "<leader>gM", "<cmd>Octo pr merge<cr>", { desc = "Merge PR(Open PR before merge)" })

-- Buffer
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
-- shift+tab bprevious
map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bN", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })

map("n", "<leader>bq", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- local opt = vim.opt
-- Copy all lines in buffer
map("n", "<C-c>", ":%y<CR>", { desc = "Copy all lines in buffer" })

-- Tab indetation, shift tab dedentation
map("v", "<Tab>", "<cmd>normal! > | gv<cr>", { desc = "Indent selected lines" })
map("v", "<S-Tab>", "<cmd>normal! < | gv<cr>", { desc = "Dedent selected lines" })

-- snacks live_grep on current directory
map("n", "<leader>fq", ":lua Snacks.dashboard.pick('live_grep')<CR>", { desc = "Snacks live_grep" })

-- terminal
map("n", "<C-t>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (cwd)" })

map("t", "<C-t>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- Focus window keymaps
-- snack explorer needed to disable <C-d> keymap
map("n", "<C-a>", "<C-w>h", { desc = "Focus left window", noremap = true, silent = true })
map("n", "<C-d>", "<C-w>l", { desc = "Focus right window", noremap = true, silent = true })
map("n", "<C-s>", "<cmd>wincmd j<CR>", { desc = "Focus down window", silent = true })
map("n", "<C-w>", "<cmd>wincmd k<CR>", { desc = "Focus up window", silent = true })

-- Exit insert mode by writing cc in insert mode
map("i", "qq", "<ESC>", { desc = "Exit insert mode" })

-- highlight the same words with * and go to word in visual mode,
--`*N` e.g <shift+n> to reverse on highlighted word, `*` to forward
-- and `cgn` would replace the word with insert, replace with new word
-- use `.` dot to repeat the same changes on everything same words
map("n", "<C-n>", "*Ncgn", { silent = true, desc = "Substitute word under cursor" })

-- Replace word under cursor with enter, it doesn't matter if it's in the last word
-- `ce` similar: but ce is change after the cursor.
map("n", "<cr>", "ciw")

-- home and end keymaps
-- https://github.com/neovim/neovim/issues/9012
-- inoremap <C-a> <Home>
-- inoremap <C-e> <End>
map("i", "<C-a>", "<Home>", { desc = "Home" })
map("i", "<C-e>", "<End>", { desc = "End" })

-- Redo - default already
-- map("n", "<C-r>", "<cmd>redo<cr>", { desc = "Redo" })

--TODO:  maybe caps2esc would be better

-- -- -- Obsidian.nvim
map("n", "<leader>fo", ":ObsidianQuickSwitch<CR>", { desc = "Obsidian File Search", silent = true })
map("n", "<leader>fO", ":ObsidianSearch<CR>", { desc = "Obsidian Search in Files", silent = true })

-- up down + ctrl to move more lines
map("n", "<C-Down>", "5j", { desc = "Move down 5 lines" })
map("n", "<C-Up>", "5k", { desc = "Move up 5 lines" })
map("n", "<C-Left>", "7h", { desc = "Move left 5 lines" })
map("n", "<C-Right>", "7l", { desc = "Move right 5 lines" })
-- switching to ctrl-j-k-l for moving between windows, c-h to switch home end on
map("n", "<C-j>", "5j", { desc = "Move to window below" })
map("n", "<C-k>", "5k", { desc = "Move to window above" })
map("n", "<C-l>", "5l", { desc = "Move to window right" })
map("n", "<C-h>", "5h", { desc = "Move to window left" })
-- for also visual mode
map("v", "<C-j>", "5j", { desc = "Move to window below" })
map("v", "<C-k>", "5k", { desc = "Move to window above" })
map("v", "<C-l>", "5l", { desc = "Move to window right" })
map("v", "<C-h>", "5h", { desc = "Move to window left" })
