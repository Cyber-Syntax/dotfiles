return {
  --TODO: fix waiting for super-tab
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
    }
  }
}
