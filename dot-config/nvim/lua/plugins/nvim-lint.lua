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
  config = function()
    local markdownlint = require("lint").linters.markdownlint
    markdownlint.args = {
      "--disable",
      "MD013", -- Disable line length rule
      "MD007", -- Disable indentation rule
      "--", -- Required to separate options from files
    }
  end,
}
