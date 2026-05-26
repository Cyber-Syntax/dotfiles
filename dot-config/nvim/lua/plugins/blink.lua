return {
  ----TODO: fix waiting for super-tab
  --- NOTE: without this, you can't accept lsp too. not only AI!
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
    },
    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      compat = {},
      default = { "lsp", "path", "snippets" },
    },
  },
}
