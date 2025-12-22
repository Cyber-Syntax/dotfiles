-- After obsidian.nvim or blink.cmp updates, completion on markdown links breaked.
--https://github.com/orgs/obsidian-nvim/discussions/557
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
      disable_frontmatter = true,

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
        img_folder = "assets/", -- This is the default
      },
      statusline = { enabled = false },
      footer = { enabled = false },
    },
  },
}
