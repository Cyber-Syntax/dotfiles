return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      -- "nvim-lua/plenary.nvim",
      { "nvim-lua/plenary.nvim", branch = "master" },
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {
      display = {
        diff = {
          provider_opts = {
            inline = {
              layout = "float", -- float|buffer - Where to display the diff
              opts = {
                context_lines = 3, -- Number of context lines in hunks
                dim = 25, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
                full_width_removed = true, -- Make removed lines span full width
                show_keymap_hints = true, -- Show "gda: accept | gdr: reject" hints above diff
                show_removed = true, -- Show removed lines as virtual text
              },
            },
          },
        },
      },
      interactions = {
        chat = {
          opts = {
            completion_provider = "blink", -- blink|cmp|coc|default
          },
          --NOTE: Minimize big context on chat
          icons = {
            chat_context = "📎️", -- You can also apply an icon to the fold
            chat_fold = " ",
          },
          fold_context = true,
          fold_reasoning = false,
          show_reasoning = false,
        },
        chat = {
          adapter = {
            name = "copilot",
            model = "gpt-4.1",
          },
        },
        inline = {
          adapter = "ollama",
          model = "llama3.2:3b-instruct-q8_0",
        },
        background = {
          adapter = {
            name = "ollama",
            model = "llama3.2:3b-instruct-q8_0",
          },
        },
      },
      adapters = {
        http = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = {
                  default = "llama3.2:3b-instruct-q8_0",
                },
                temperature = {
                  order = 2,
                  mapping = "parameters",
                  type = "number",
                  default = 0.2,
                },
                num_ctx = {
                  order = 3,
                  mapping = "parameters",
                  type = "number",
                  default = 4096,
                },
                repeat_last_n = {
                  order = 4,
                  mapping = "parameters",
                  type = "number",
                  default = 64,
                },
                repeat_penalty = {
                  order = 5,
                  mapping = "parameters",
                  type = "number",
                  default = 1.1,
                },
                seed = {
                  order = 6,
                  mapping = "parameters",
                  type = "number",
                  default = 0,
                },
                stop = {
                  order = 7,
                  mapping = "parameters",
                  type = "table",
                  default = { "<|im_end|>", "<|endoftext|>" },
                },
                top_k = {
                  order = 8,
                  mapping = "parameters",
                  type = "number",
                  default = 40,
                },
                top_p = {
                  order = 9,
                  mapping = "parameters",
                  type = "number",
                  default = 0.9,
                },
                min_p = {
                  order = 10,
                  mapping = "parameters",
                  type = "number",
                  default = 0.05,
                },
                keep_alive = {
                  order = 11,
                  mapping = "parameters",
                  type = "number",
                  default = 30,
                },
              },
              headers = {
                ["Content-Type"] = "application/json",
              },
              parameters = {
                sync = true,
              },
            })
          end,
        },
      },
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
}
