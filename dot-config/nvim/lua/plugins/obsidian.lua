--TODO: blink is actualy completion so it is same like nvim_cmp, seems deprecated
-- setup a way to disable lsp and continue usin this which lsp seems won't work with marksman?
-- https://github.com/obsidian-nvim/obsidian.nvim/issues/755
--
--TODO: completion.nvim_cmp is deprecated, use removing it from your config.
-- Completion is now provided via the built-in obsidian-ls LSP server instead.
-- Feature will be removed in obsidian.nvim 4.0
--
-- Workaround seems work but still not handle old files like 2023,
-- it's always make it 2026 in copy. (checkout options.lua for workaround.)
-- this is probably because of neovim issue:
-- https://github.com/neovim/neovim/issues/29671
-- Get the file creation time from the filesystem.
-- Used only when a note does not already have a `created` field.
local function get_birthtime(filename)
  local stat = vim.uv.fs_stat(filename)

  -- Make sure birthtime exists and is valid before using it.
  if stat and stat.birthtime and stat.birthtime.sec and stat.birthtime.sec > 0 then
    return os.date("%Y-%m-%d %H:%M:%S", stat.birthtime.sec)
  end
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "saghen/blink.cmp",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in 4.0.0
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/obsidian/main-vault/",
        },
      },
      --TODO: https://github.com/obsidian-nvim/obsidian.nvim/issues/437
      --NOTE: workaround to remove zettalkasten id to keep created file name title instead of id
      -- e.g title-for-file.md instead of 1253AZBASD.md
      note_id_func = function(title)
        if title == nil then
          return require("obsidian.builtin").zettle_id
        end

        -- Keep the title as-is
        return title
      end,
      -- Optional, if you keep notes in a specific subdirectory of your vault.
      notes_subdir = "1.INBOX",
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "notes_subdir",

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "daily_note",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "daily-review.md",
      },

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- Set to false to disable completion.
        blink = true,
      },

      link = {
        style = "markdown",
        --NOTE: keep it absolute to make it global for other apps
        -- Example absolute: [linux-Notes](11_System-Administrator/11.01_Linux/Linux-Notes/Linux-Notes.md)
        format = "absolute",
      },

      -- Optional, boolean or a function that takes a filename and returns a boolean.
      -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
      -- disable_frontmatter = true,
      -- frontmatter_enabled = false,
      --TESTING: auto created, updated frontmatter yaml
      frontmatter = {
        enabled = true,

        ---@type fun(note: obsidian.Note): table<string, any>
        func = function(note)
          local out = {}

          -- Keep all existing frontmatter fields
          if note.metadata and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end

          -- Only create the `created` field once.
          -- If it already exists, keep the original value forever.
          if out.created == nil then
            out.created = get_birthtime(note.path.filename) or os.date("%Y-%m-%d %H:%M:%S")
          end

          -- always refresh last_modified
          out.last_modified = os.date("%Y-%m-%d %H:%M:%S")

          return out
        end,
      },

      -- Optional, for templates (see below).
      templates = {
        folder = "10_Dashboard/10.02_Templates/",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "snacks.pick",
      },

      --NOTE: we uses render-markdown.nvim for better view, and this isn't working with it
      ui = {
        enable = false, -- set to false to disable all additional syntax features
      },

      attachments = {
        folder = "assets/",
      },
      statusline = { enabled = false },
      footer = { enabled = false },
    },
  },
}
