return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        -- NOTE: disable pyright/basedpyright to enable ruff linting/formating
        pyright = {
          settings = {
            pyright = {
              typeCheckingMode = "basic",
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
              },
            },
          },
        },
        -- Enable ty astral mypy alternative
        ty = {
          settings = {
            ty = {
              configuration = {
                rules = {
                  ["unresolved-reference"] = "warn",
                },
              },
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "recommended",
                ignore = { "*" },
              },
              disableOrganizeImports = true,
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              diagnostics = false,
              lineLength = 79,
              fixAll = true, -- Enable auto-fix for all violations
              organizeImports = true, -- Explicitly enable import organization
              lint = {
                select = { "ALL" },
                ignore = {
                  "B010",
                  "E202",
                  "D202",
                  "D212",
                  "D203",
                  "D211",
                  "D213",
                  "W191",
                  "E111",
                  "E114",
                  "E117",
                  "D206",
                  "D300",
                  "Q000",
                  "Q001",
                  "Q002",
                  "Q003",
                  "COM812",
                  "COM819",
                  "CPY001",
                  "ISC001",
                  "TD002",
                  "TD003",
                  "E501",
                },
              },
            },
          },
        },
      },
      diagnostics = {
        signs = true, -- disable left guttor icons
        underline = false,
        update_in_insert = true,
        severitiy = { vim.diagnostic.severity.ERROR },
        virtual_text = false,
        float = {
          source = "always", -- show diagnostic source in float
          border = "rounded",
        },
      },
    },
  },
}
