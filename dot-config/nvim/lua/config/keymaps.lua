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

--     :Obsidian today [OFFSET] - open/create a new daily note
--         offset is in days, e.g. use :Obsidian today -1 to go to yesterday's note.
--         Unlike :Obsidian yesterday and :Obsidian tomorrow this command does not differentiate between weekdays and weekends

-- -- -- Obsidian.nvim
map("n", "<leader>fo", ":Obsidian quick_switch<CR>", { desc = "Obsidian File Search", silent = true })
map("n", "<leader>fO", ":Obsidian search<CR>", { desc = "Obsidian Search in Files", silent = true })
map("n", "<leader>fd", ":Obsidian today<CR>", { desc = "Obsidian open/create a new daily note", silent = true })
map(
  "n",
  "<leader>fy",
  ":Obsidian yesterday<CR>",
  { desc = "Obsidian open/create the daily note for the previous working day", silent = true }
)
map(
  "n",
  "<leader>fY",
  ":Obsidian tomorrow<CR>",
  { desc = "Obsidian open/create the daily note for the next working day", silent = true }
)

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

-- Codecompanion.nvim
map(
  { "n", "v" },
  "<leader>ac",
  "<cmd>CodeCompanionActions<cr>",
  { noremap = true, silent = true, desc = "CodeCompanion Actions" }
)
map(
  { "n", "v" },
  "<leader>aC",
  "<cmd>CodeCompanionChat Toggle<cr>",
  { noremap = true, silent = true, desc = "CodeCompanion Chat Toggle" }
)
map(
  "v",
  "<leader>ae",
  "<cmd>CodeCompanionChat Add<cr>",
  { noremap = true, silent = true, desc = "CodeCompanion Chat Add" }
)

-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
-- vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
--
-- -- Expand 'cc' into 'CodeCompanion' in the command line
-- vim.cmd([[cab cc CodeCompanion]])

--TODO: send these to seperated file as custom functions
-- -- -- Custom toggle checkbox function
-- Markdown TODO utilities
local M = {}

-- Toggle checkbox on current line
function M.toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  if line:find("%[ %]") then
    line = line:gsub("%[ %]", "[x]", 1)
    vim.api.nvim_set_current_line(line)
    M.move_to_done()
  elseif line:find("%[x%]") then
    line = line:gsub("%[x%]", "[ ]", 1)
    vim.api.nvim_set_current_line(line)
  else
    return
  end
end

function M.move_to_done()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local start_row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local current_line = lines[start_row + 1]

  -- Only process checkbox lines
  if not current_line:find("^%s*%- %[") then
    return
  end

  -- Determine initial indentation level
  local initial_indent = current_line:match("^(%s*)")
  local initial_indent_len = #initial_indent

  local end_row = start_row

  -- Collect all lines that belong to this task (look forward only)
  for i = start_row + 2, #lines do
    local l = lines[i]

    -- Stop at headings
    if l:find("^#") then
      break
    end

    -- Empty lines - include them for now
    if l == "" then
      end_row = i - 1
    else
      local line_indent = l:match("^(%s*)")
      local line_indent_len = #line_indent

      -- Check if this is a checkbox line
      if l:find("^%s*%- %[") then
        -- If it's indented more than the parent, it's a subtask - include it
        if line_indent_len > initial_indent_len then
          end_row = i - 1
        else
          -- Same or less indentation - it's a sibling or parent, stop here
          break
        end
      else
        -- Non-checkbox line (description, code block, etc.)
        -- Include if indented more than the task
        if line_indent_len > initial_indent_len then
          end_row = i - 1
        else
          -- Same or less indentation, stop here
          break
        end
      end
    end
  end

  local task_lines = {}
  for i = start_row, end_row do
    table.insert(task_lines, lines[i + 1])
  end
  local delete_count = end_row - start_row + 1

  -- Find done section (support both # and ## headings)
  local done_row = -1
  for i = 1, #lines do
    if lines[i]:find("^##? done") or lines[i]:find("^##? Done") then
      done_row = i - 1
      break
    end
  end

  if done_row ~= -1 then
    -- Adjust done_row if we're deleting before it
    if start_row <= done_row then
      done_row = done_row - delete_count
    end
    done_row = done_row + 1
  end

  -- Delete task from original location
  vim.api.nvim_buf_set_lines(buf, start_row, end_row + 1, false, {})

  if done_row == -1 then
    done_row = vim.api.nvim_buf_line_count(buf)
  end

  -- Insert task after done heading
  vim.api.nvim_buf_set_lines(buf, done_row, done_row, false, task_lines)
end

-- Insert new TODO line
function M.new_todo()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, { "- [ ] " })
  vim.api.nvim_win_set_cursor(0, { row + 1, 6 })
  vim.defer_fn(function()
    vim.cmd.startinsert()
  end, 10)
end

-- Keymaps
vim.keymap.set("n", "<leader>tt", M.toggle_checkbox, { desc = "Toggle Markdown Checkbox", silent = true })
vim.keymap.set("n", "<leader>tn", M.new_todo, { desc = "Insert new TODO", silent = true })

vim.keymap.set("i", "<C-t>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  M.new_todo()
end, { desc = "Insert new TODO", silent = true })
