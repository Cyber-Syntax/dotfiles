-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
-- vim.g.root_spec = { "cwd" }

--NOTE: soft wrap for text in custom size like 80 not implemented to neovim yet
-- https://github.com/neovim/neovim/issues/4386
--TODO: enable soft wrap for markdown, text, .log files after this is implemented in neovim
--NOTE: below make hard wrap when writing
-- Set text width to 79 characters
-- vim.opt.textwidth = 79
-- enable line wrapping
vim.opt.wrap = true
-- enable line breaking at word boundaries
-- vim.opt.linebreak = true
-- -- enable break indent
-- vim.opt.breakindent = true

--NOTE: for edgy.nvim
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
vim.opt.splitkeep = "screen"

--NOTE: other options
vim.o.background = "dark" -- or "light" for light mode
--Hide The order of your lazy.nvim warning
vim.g.lazyvim_check_order = false

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

vim.o.updatetime = 250
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

-- vim.lsp.inlay_hint(0, false)
-- Those already default
-- local opt = vim.opt
-- vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
