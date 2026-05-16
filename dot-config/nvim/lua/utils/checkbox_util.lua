-- Markdown TODO utilities (Obsidian Kanban aware)
--
-- Features:
-- 1. Toggle checkbox between [ ] and [x]
-- 2. Create checkbox on current line if none exists
-- 3. Move completed parent tasks to ## Done section
-- 4. Preserve subtasks + descriptions with parent
-- 5. Obsidian Kanban plugin compatible
--
-- IMPORTANT:
-- - Tasks are inserted DIRECTLY under the Done heading
-- - NEVER below "**Complete**"
-- - NEVER inside %% kanban:settings block
-- - Subtasks do NOT move independently
-- - Completing a parent moves entire subtree
--
-- Works with:
--
-- ## Done
--
-- **Complete**
--
-- %% kanban:settings
-- ...
--
local M = {}

-- =========================
-- Helpers
-- =========================

local function is_checkbox(line)
  return line:find("^%s*%- %[")
end

local function get_indent_len(line)
  local indent = line:match("^(%s*)") or ""
  return #indent
end

local function is_heading(line)
  return line:find("^#")
end

local function is_done_heading(line)
  return line:lower():find("^##? done")
end

local function is_kanban_settings(line)
  return line:find("^%%%% kanban:")
end

-- Returns true if current task is a subtask
local function is_subtask(lines, row)
  local current_line = lines[row + 1]

  if not current_line then
    return false
  end

  local current_indent = get_indent_len(current_line)

  -- top-level task
  if current_indent == 0 then
    return false
  end

  -- walk upward until heading/file start
  for i = row, 1, -1 do
    local l = lines[i]

    if is_heading(l) then
      break
    end

    if is_checkbox(l) then
      local indent = get_indent_len(l)

      -- ANY checkbox with lower indentation
      -- is a parent task
      if indent < current_indent then
        return true
      end
    end
  end

  return false
end
-- Collect task + children
local function collect_task_block(lines, start_row)
  local base_line = lines[start_row + 1]
  local base_indent = get_indent_len(base_line)

  local end_row = start_row

  for i = start_row + 2, #lines do
    local l = lines[i]

    -- stop at heading
    if is_heading(l) then
      break
    end

    -- blank lines belong to current block
    if l == "" then
      end_row = i - 1
      goto continue
    end

    local indent = get_indent_len(l)

    -- another checkbox at same or smaller indent
    -- means sibling/new task
    if is_checkbox(l) and indent <= base_indent then
      break
    end

    -- otherwise belongs to this task tree
    end_row = i - 1

    ::continue::
  end

  local task_lines = {}

  for i = start_row, end_row do
    table.insert(task_lines, lines[i + 1])
  end

  return task_lines, end_row
end

-- =========================
-- Toggle checkbox
-- =========================

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
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local indent = line:match("^(%s*)") or ""
    local content = line:match("^%s*(.-)%s*$") or ""

    local new_line

    if content == "" then
      new_line = indent .. "- [ ] "
    else
      new_line = indent .. "- [ ] " .. content
    end

    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { row, #indent + 6 })
  end
end

-- =========================
-- Move completed task
-- =========================

function M.move_to_done()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local start_row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local current_line = lines[start_row + 1]

  -- only checkbox tasks
  if not is_checkbox(current_line) then
    return
  end

  -- DO NOT move subtasks independently
  if is_subtask(lines, start_row) then
    return
  end

  -- collect task + subtasks + descriptions
  local task_lines, end_row = collect_task_block(lines, start_row)

  local delete_count = end_row - start_row + 1

  -- find Done heading
  local done_row = nil

  for i, line in ipairs(lines) do
    if is_done_heading(line) then
      done_row = i - 1
      break
    end
  end

  -- remove original task
  vim.api.nvim_buf_set_lines(buf, start_row, end_row + 1, false, {})

  if done_row and start_row <= done_row then
    done_row = done_row - delete_count
  end

  -- refresh lines
  local updated_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- if no done section -> append
  if not done_row then
    local line_count = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, task_lines)
    return
  end

  -- =========================================================
  -- IMPORTANT:
  -- Insert DIRECTLY BELOW Done heading
  --
  -- We intentionally IGNORE:
  --   **Complete**
  --   kanban settings
  --   metadata
  --
  -- because Obsidian Kanban expects tasks immediately
  -- under the heading.
  -- =========================================================

  local insert_row = done_row + 1

  -- skip ONE optional blank line after heading
  if updated_lines[insert_row + 1] == "" then
    insert_row = insert_row + 1
  end

  -- insert task directly under heading
  vim.api.nvim_buf_set_lines(buf, insert_row, insert_row, false, task_lines)
end

-- =========================
-- New TODO
-- =========================

function M.new_todo()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  vim.api.nvim_buf_set_lines(0, row, row, false, {
    "- [ ] ",
  })

  vim.api.nvim_win_set_cursor(0, { row + 1, 6 })

  vim.defer_fn(function()
    vim.cmd.startinsert()
  end, 10)
end

return M
