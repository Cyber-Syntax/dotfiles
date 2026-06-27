return {
  --NOTE: last one always win because of colorscheme config call
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        transparent_background = false,
        terminal_colors = true,
        devicons = true,
        styles = {
          comment = { italic = true },
          keyword = { italic = true },
          type = { italic = true },
          storageclass = { italic = false },
          structure = { italic = true },
          parameter = { italic = true },
          annotation = { italic = true },
          tag_attribute = { italic = true },
        },
        filter = "octagon", -- classic | octagon | pro | machine | ristretto | spectrum
        day_night = {
          enable = false,
          day_filter = "pro",
          night_filter = "spectrum",
        },
        inc_search = "background", -- underline | background
        background_clear = {
          "toggleterm",
          "telescope",
          "renamer",
          "notify",
        },
        plugins = {
          bufferline = {
            underline_selected = true,
            underline_visible = true,
            underline_fill = false,
            bold = true,
          },
          indent_blankline = {
            context_highlight = "pro", -- default | pro
            context_start_underline = true,
          },
        },
        -- override = function(scheme)
        --   return {
        --     IndentBlanklineChar = { fg = scheme.base.dimmed4 },
        --   }
        -- end,
      })
      vim.cmd("colorscheme monokai-pro-light")
    end,
  },

  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   lazy = false,
  --   config = function()
  --     require("gruvbox").setup({
  --       terminal_colors = true, -- add neovim terminal colors
  --       undercurl = true,
  --       underline = true,
  --       bold = true,
  --       italic = {
  --         strings = true,
  --         emphasis = true,
  --         comments = true,
  --         operators = false,
  --         folds = true,
  --       },
  --       strikethrough = true,
  --       invert_selection = false,
  --       invert_signs = false,
  --       invert_tabline = false,
  --       inverse = true, -- invert background for search, diffs, statuslines and errors
  --       contrast = "soft", -- can be "hard", "soft" or empty string
  --       palette_overrides = {},
  --       overrides = {},
  --       dim_inactive = false,
  --       transparent_mode = false,
  --     })
  --     vim.cmd("colorscheme gruvbox")
  --     --NOTE: force light theme here, options.lua can't force it probably because of lazyvim default enabled disable dark background thing
  --     vim.o.background = "light"
  --   end,
  -- },

  -- -- sainnhe/gruvbox-material
  -- {
  --   "sainnhe/gruvbox-material",
  --   priority = 1000,
  --   config = function()
  --     --NOTE: you can assign like this to override options.lua
  --     -- vim.o.background = "light" -- or "dark"
  --     -- vim.cmd("colorscheme gruvbox-material")
  --   end,
  -- },

  -- {
  --   "neanias/everforest-nvim",
  --   version = false,
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   -- Optional; default configuration will be used if setup isn't called.
  --   config = function()
  --     require("everforest").setup({
  --       ---Controls the "hardness" of the background. Options are "soft", "medium" or "hard".
  --       background = "hard",
  --       ---How much of the background should be transparent. 2 will have more UI
  --       ---components be transparent (e.g. status line background)
  --       transparent_background_level = 0,
  --       ---Whether italics should be used for keywords and more.
  --       italics = false,
  --       ---Disable italic fonts for comments. Comments are in italics by default, set
  --       ---this to `true` to make them _not_ italic!
  --       disable_italic_comments = false,
  --       ---By default, the colour of the sign column background is the same as the as normal text
  --       ---background, but you can use a grey background by setting this to `"grey"`.
  --       sign_column_background = "none",
  --       ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
  --       ---`"low"` (default).
  --       ui_contrast = "low",
  --       ---Dim inactive windows. Only works in Neovim. Can look a bit weird with Telescope.
  --       ---
  --       ---When this option is used in conjunction with show_eob set to `false`, the
  --       ---end of the buffer will only be hidden inside the active window. Inside
  --       ---inactive windows, the end of buffer filler characters will be visible in
  --       ---dimmed symbols. This is due to the way Vim and Neovim handle `EndOfBuffer`.
  --       dim_inactive_windows = false,
  --       ---Some plugins support highlighting error/warning/info/hint texts, by
  --       ---default these texts are only underlined, but you can use this option to
  --       ---also highlight the background of them.
  --       diagnostic_text_highlight = false,
  --       ---Which colour the diagnostic text should be. Options are `"grey"` or `"coloured"` (default)
  --       diagnostic_virtual_text = "coloured",
  --       ---Some plugins support highlighting error/warning/info/hint lines, but this
  --       ---feature is disabled by default in this colour scheme.
  --       diagnostic_line_highlight = false,
  --       ---By default, this color scheme won't colour the foreground of |spell|, instead
  --       ---colored under curls will be used. If you also want to colour the foreground,
  --       ---set this option to `true`.
  --       spell_foreground = false,
  --       ---Whether to show the EndOfBuffer highlight.
  --       show_eob = true,
  --       ---Style used to make floating windows stand out from other windows. `"bright"`
  --       ---makes the background of these windows lighter than |hl-Normal|, whereas
  --       ---`"dim"` makes it darker.
  --       ---
  --       ---Floating windows include for instance diagnostic pop-ups, scrollable
  --       ---documentation windows from completion engines, overlay windows from
  --       ---installers, etc.
  --       ---
  --       ---NB: This is only significant for dark backgrounds as the light palettes
  --       ---have the same colour for both values in the switch.
  --       float_style = "bright",
  --       ---Inlay hints are special markers that are displayed inline with the code to
  --       ---provide you with additional information. You can use this option to customize
  --       ---the background color of inlay hints.
  --       ---
  --       ---Options are `"none"` or `"dimmed"`.
  --       inlay_hints_background = "none",
  --     })
  --     -- vim.o.background = "light" -- or "dark"
  --     -- vim.cmd("colorscheme everforest")
  --   end,
  -- },

  -- -- ONEDARK
  -- {
  --   "olimorris/onedarkpro.nvim",
  --   priority = 1000, -- Ensure it loads first
  --   config = function()
  --     require("onedarkpro").setup({
  --       -- Your config here
  --     })
  --     vim.o.background = "light" -- or "dark"
  --     -- vim.cmd("colorscheme onelight")
  --   end,
  -- },
}
