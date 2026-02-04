-- After obsidian.nvim or blink.cmp updates, completion on markdown links breaked.
--https://github.com/orgs/obsidian-nvim/discussions/557
--TODO: commands are changed on new version, two command updated on keymap
-- Lets move keymaps to here for better DRY princible
-- and add other useful keymaps from this:
-- Top level commands
--
--     :Obsidian dailies [OFFSET ...] - open a picker list of daily notes
--         :Obsidian dailies -2 1 to list daily notes from 2 days ago until tomorrow
--     :Obsidian new [TITLE] - create a new note
--     :Obsidian open [QUERY] - open a note in the Obsidian app
--         query is used to resolve the note to open by ID, path, or alias, else use current note
--     :Obsidian today [OFFSET] - open/create a new daily note
--         offset is in days, e.g. use :Obsidian today -1 to go to yesterday's note.
--         Unlike :Obsidian yesterday and :Obsidian tomorrow this command does not differentiate between weekdays and weekends
--     :Obsidian tomorrow - open/create the daily note for the next working day
--     :Obsidian yesterday - open/create the daily note for the previous working day
--     :Obsidian new_from_template [TITLE] [TEMPLATE] - create a new note with TITLE from a template with the name TEMPLATE
--         both arguments are optional. If not given, the template will be selected from a list using your preferred picker
--     :Obsidian quick_switch - switch to another note in your vault, searching by its name with a picker
--     :Obsidian search [QUERY] - search for (or create) notes in your vault using ripgrep with your preferred picker
--     :Obsidian tags [TAG ...] - get a picker list of all occurrences of the given tags
--     :Obsidian workspace [NAME] - switch to another workspace
--
-- Note commands
--
--     :Obsidian backlinks - get a picker list of references to the current note
--         grr/vim.lsp.buf.references to see references in quickfix list
--     :Obsidian follow_link [STRATEGY] - follow a note reference under the cursor
--         available strategies: vsplit, hsplit, vsplit_force, hsplit_force
--     :Obsidian toc - get a picker list of table of contents for current note
--     :Obsidian template [NAME] - insert a template from the templates folder, selecting from a list using your preferred picker
--         Template
--     :Obsidian links - get a picker list of all links in current note
--     :Obsidian paste_img [IMGNAME] - paste an image from the clipboard into the note at the cursor position by saving it to the vault and adding a markdown image link
--         Images
--     :Obsidian rename [NEWNAME] - rename the note of the current buffer or reference under the cursor, updating all backlinks across the vault
--         runs :wa before renaming, and loads every note with backlinks into your buffer-list
--         after renaming you need to do :wa again for changes to take effect
--         alternatively, call vim.lsp.buf.rename or use grn
--     :Obsidian toggle_checkbox - cycle through checkbox options
--
-- Visual mode commands
--
--     :Obsidian extract_note [TITLE] - extract the visually selected text into a new note and link to it
--     :Obsidian link [QUERY] - link an inline visual selection of text to a note
--         query will be used to resolve the note by ID, path, or alias, else query is selected text
--     :Obsidian link_new [TITLE] - create a new note and link it to an inline visual selection of text
--         if title is not given, selected text is used
--

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
      legacy_commands = false, -- this will be removed in the next major release
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
        nvim_cmp = false,
        blink = true,
      },

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = "markdown",

      -- Optional, boolean or a function that takes a filename and returns a boolean.
      -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
      -- disable_frontmatter = true,
      frontmatter_enabled = false,

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
