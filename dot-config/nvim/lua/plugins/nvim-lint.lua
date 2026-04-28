return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
        python = { "ruff", "ty" },
      },
    },
  },
}
