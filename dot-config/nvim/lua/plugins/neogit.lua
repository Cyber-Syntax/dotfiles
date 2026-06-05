return {
  -- {
  --   "m00qek/baleia.nvim",
  --   version = "*",
  --   config = function()
  --     vim.g.baleia = require("baleia").setup({})
  --
  --     -- Command to colorize the current buffer
  --     vim.api.nvim_create_user_command("BaleiaColorize", function()
  --       vim.g.baleia.once(vim.api.nvim_get_current_buf())
  --     end, { bang = true })
  --
  --     -- Command to show logs
  --     vim.api.nvim_create_user_command("BaleiaLogs", vim.cmd.messages, { bang = true })
  --   end,
  -- },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      -- Only one of these is needed.

      -- (this old repo)sindrets/diffview fork:
      -- dlyongemallo/diffview.nvim
      "esmuellert/codediff.nvim", -- optional

      -- For a custom log pager
      "m00qek/baleia.nvim", -- optional

      -- Only one of these is needed.
      -- "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua", -- optional
      -- "nvim-mini/mini.pick", -- optional
      "folke/snacks.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
}
