return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    -- add options here
    -- or leave it empty to use the default settings
    default = {
      -- Better to not use absolute path, so it would work across different machines
      use_absolute_path = false, ---@type boolean
      drag_and_drop = {
        enabled = true, ---@type boolean | fun(): boolean
        insert_mode = false, ---@type boolean | fun(): boolean
      },
    },
  },
  keys = {
    -- suggested keymap
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
}
