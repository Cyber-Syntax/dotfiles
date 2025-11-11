return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      -- Don't use absolute paths for more than one machine use
      use_absolute_path = false,
      relative_to_current_file = true,
      drag_and_drop = {
        enabled = true,
        insert_mode = false,
      },
    },
  },
  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
}
