return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {
      enable_builtin = true,
      default_to_projects_v2 = false,
      default_merge_method = "squash",
      picker = "snacks",
    },
    keys = {
      { "<leader>gc", "<cmd>Octo issue create<CR>", desc = "Create Issue (Octo)" },
    },
  },
}
