return {
  { "rcarriga/nvim-notify", enabled = false },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = {
          enabled = false, -- disable right left loading for basedpyright etc.
        },
      },
      cmdline = {
        view = "cmdline", -- moves command line to bottom
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_pallette = false, -- tab completions for commandline don't pop-up at top
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true, -- add a border to hover docs and signature
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
    },
  },
}
