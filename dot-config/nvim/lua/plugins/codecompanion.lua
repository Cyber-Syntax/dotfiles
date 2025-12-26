return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    config = function()
      require("codecompanion").setup({
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              chat = {
                adapter = {
                  name = "copilot",
                  --TODO: add other models like claude-4.5-sonnet ?
                  model = "raptor-mini",
                },
                tools = {
                  opts = {
                    auto_submit_errors = true,
                    auto_submit_success = true,
                  },
                },
              },
              --NOTE: use `/memory` on chat to add AGENTS.md to memory
              --TODO: custom prompts: https://codecompanion.olimorris.dev/extending/prompts
              -- if you want to add custom prompts but you can't use external directories
              -- (https://github.com/olimorris/codecompanion.nvim/discussions/1969),
              -- only here inside the setup function
              memory = {
                default = {
                  description = "AGENTS.md file as context for projects",
                  files = {
                    "AGENTS.md",
                  },
                },
                opts = {
                  chat = {
                    default_memory = "default",
                  },
                },
              },
            })
          end,
        },
        opts = {
          log_level = "DEBUG",
        },
      })

      local keymap = vim.keymap
      keymap.set(
        { "n", "v" },
        "<leader>ac",
        "<cmd>CodeCompanionActions<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion Actions" }
      )
      keymap.set(
        { "n", "v" },
        "<leader>aC",
        "<cmd>CodeCompanionChat Toggle<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion Chat Toggle" }
      )
      keymap.set(
        "v",
        "<leader>ae",
        "<cmd>CodeCompanionChat Add<cr>",
        { noremap = true, silent = true, desc = "CodeCompanion Chat Add" }
      )
    end,
  },
}
