-- Markdown TODO utilities
--
-- Features:
-- 1. Toggle checkbox between [ ] and [x]
-- 2. Create checkbox on current line if none exists (preserves existing content)
-- 3. Move completed tasks to ## done section with all subtasks intact
-- 4. Properly handle kanban plugin settings block at end of file
--
-- Usage:
--   <leader>tt - Toggle checkbox or create one if it doesn't exist
--   <leader>tn - Insert new TODO line
--
-- When moving to done:
--   - Keeps all subtasks (indented checkboxes) with the parent task
--   - Keeps all description lines (indented content) with the task
--   - Inserts at end of done section (before kanban settings or next heading)
--   - Adds one blank line after "## done" header for first item only
--   - No blank lines between subsequent done items
--
local M = {}

-- Toggle checkbox on current line or create one if it doesn't exist
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
    -- No checkbox found, create one on the current line
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local indent = line:match("^(%s*)")
    local content = line:match("^%s*(.-)%s*$") or "" -- trim whitespace

    -- Create checkbox with existing content
    local new_line
    if content == "" then
      new_line = indent .. "- [ ] "
    else
      new_line = indent .. "- [ ] " .. content
    end

    vim.api.nvim_set_current_line(new_line)
    -- Position cursor after "- [ ] " (6 characters after indent)
    vim.api.nvim_win_set_cursor(0, { row, #indent + 6 })
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

    -- Empty lines - continue checking if they're part of the task
    if l ~= "" then
      local line_indent = l:match("^(%s*)")
      local line_indent_len = #line_indent

      -- Check if this is a checkbox line
      if l:find("^%s*%- %[") then
        -- If it's indented more than the parent, it's a subtask - include it
        if line_indent_len > initial_indent_len then
          end_row = i - 1  -- Track last line that belongs to this task
        else
          -- Same or less indentation - it's a sibling or parent, stop here
          break
        end
      else
        -- Non-checkbox line (description, code block, etc.)
        -- Include if indented more than the task
        if line_indent_len > initial_indent_len then
          end_row = i - 1  -- Track last line that belongs to this task
        else
          -- Same or less indentation, stop here
          break
        end
      end
    else
      -- Empty line might separate tasks or be part of description
      -- Tentatively mark it as part of the task, but will be overridden
      -- if we find content after it that doesn't belong
      end_row = i - 1
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

  -- Delete task from original location first
  vim.api.nvim_buf_set_lines(buf, start_row, end_row + 1, false, {})

  -- Adjust done_row if we're deleting before it
  if done_row ~= -1 and start_row <= done_row then
    done_row = done_row - delete_count
  end

  if done_row ~= -1 then
    -- Get updated lines after deletion
    local updated_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    -- Find where to insert: end of done section (before next heading, kanban settings, or EOF)
    local insert_row = done_row + 1  -- Start right after the done heading

    for i = done_row + 2, #updated_lines do
      local line = updated_lines[i]
      -- Stop at next heading
      if line:find("^#") then
        insert_row = i - 1
        break
      end
      -- Stop at kanban settings block (needs to stay at end)
      if line:find("^%%%% kanban:") then
        insert_row = i - 1
        break
      end
      insert_row = i
    end

    -- Check if this is the first item in done section
    local is_first_done_item = (insert_row == done_row + 1)

    -- Prepare lines to insert
    local lines_to_insert = {}
    if is_first_done_item then
      -- Add one blank line after the done heading
      table.insert(lines_to_insert, "")
    end

    -- Add the task lines
    for _, line in ipairs(task_lines) do
      table.insert(lines_to_insert, line)
    end

    -- Insert at the end of done section
    vim.api.nvim_buf_set_lines(buf, insert_row, insert_row, false, lines_to_insert)
  else
    -- No done section found, append at end of file
    local line_count = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, task_lines)
  end
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

return M
