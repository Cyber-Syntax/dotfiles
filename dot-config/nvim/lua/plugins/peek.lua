return {
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup({
        auto_load = true, -- whether to automatically load preview when entering another markdown buffer
        close_on_bdelete = true, -- close preview window on buffer delete
        syntax = true, -- enable syntax highlighting, affects performance
        theme = "light", -- 'dark' or 'light'
        update_on_change = true,
        app = { "/home/developer/Applications/helium-linux.AppImage", "--new-window" }, -- 'webview', 'browser', string or a table of strings
        filetype = { "markdown" }, -- list of filetypes to recognize as markdown
        throttle_at = 200000, -- start throttling when file exceeds this amount of bytes
        throttle_time = "auto", -- minimum time in ms before starting new render
      })
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
}
