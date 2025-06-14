return {
  {
    "olimorris/codecompanion.nvim",
    -- opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },

    opts = function(_, opts)
      local custom_opts = {
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  order = 1,
                  mapping = "parameters",
                  type = "enum",
                  desc = "ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.",
                  ---@type string|fun(): string
                  default = "claude-3.7-sonnet",
                  choices = {
                    "claude-3.5-sonnet",
                    "claude-3.7-sonnet",
                    "gpt-4o-2024-08-06",
                  },
                },
              },
            })
          end,
        },
        prompt_library = {
          ["copilot"] = {
            strategy = "chat",
            description = "Read and discuss the Copilot instructions from the file",
            opts = {
              auto_submit = false,
              short_name = "copilot",
            },
            references = {
              {
                type = "file",
                path = ".github/copilot-instructions.md",
              },
            },
            prompts = {
              {
                role = "user",
                content = "Use the instructions provided in the file carefully and follow them to the letter and generate a response according to the instructions.",
                opts = {
                  contains_code = false,
                },
              },
            },
          },
        },
      }
      return vim.tbl_deep_extend("force", opts, custom_opts)
    end,

    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },
}
