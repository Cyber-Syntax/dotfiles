return {
  "nomnivore/ollama.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  -- All the user commands added by the plugin
  cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

  keys = {
    -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
    {
      "<leader>ao",
      ":<c-u>lua require('ollama').prompt()<cr>",
      desc = "ollama prompt",
      mode = { "n", "v" },
    },

    -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
    {
      "<leader>aG",
      ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
      desc = "ollama Generate Code",
      mode = { "n", "v" },
    },
  },

  ---@type Ollama.Config
  opts = {
    -- your configuration overrides
    model = "llama3.2:latest",
    url = "http://127.0.0.1:11434",
    serve = {
      on_start = false,
      command = "ollama",
      args = { "serve" },
      stop_command = "pkill",
      stop_args = { "-SIGTERM", "ollama" },
    },
    -- View the actual default prompts in ./lua/ollama/prompts.lua
    prompts = {
      grammar_fix_strict = {
        -- prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
        prompt = "Please correct the grammar, spelling, and punctuation mistakes in the following text while preserving the original wording, structure, markdown syntax, and any special characters or placeholders (e.g., %1). Please, also review and revise the following text to make it sound more like something a native English speaker would say. If there are any opportunities to make the wording sound more natural or conversational, feel free to adjust it without altering the context. Provide the corrected version without additional notes or explanations. \n```$ftype\n$sel\n```",
        input_label = "> ",
        model = "llama3.2:latest",
        action = "display",
      },

      translate_turkish = {
        -- prompt = "This is a sample prompt that receives $input and $sel(ection), among others.",
        prompt = "Translate the turkish language.  \n```$ftype\n$sel\n```",
        input_label = "> ",
        model = "llama3.2:latest",
        action = "display",
      },
    },
  },
}
