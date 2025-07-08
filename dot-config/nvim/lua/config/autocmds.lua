-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

-- Save session for the current project via persistence.nvim
-- autocmd VimLeave * execute
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

vim.o.updatetime = 250
--vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

--NOTE: add virtual text for diagnostics
-- vim.diagnostic.config({
--   virtual_text = true,
--   virtual_lines = { current_line = true },
--   underline = true,
--   update_in_insert = false,
-- })

-- Remove whitespace on save
autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e",
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
  pattern = "",
  command = "set fo-=c fo-=r fo-=o",
})
-- Disable spell check
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Disable spell checking entirely in markdown:
    vim.opt_local.spell = false

    --FIXME: need to be able to use only english spellcheck
    -- Or, if you want to enable spell but exclude Italian, set spelllang explicitly:
    -- vim.opt_local.spell = true
    -- vim.opt_local.spelllang = "en_us" -- only English, no Italian
  end,
})
