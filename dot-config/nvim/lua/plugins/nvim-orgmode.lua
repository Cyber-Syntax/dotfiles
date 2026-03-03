return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      -- Org Files
      org_agenda_files = "~/Documents/orgfiles/**/*",
      org_default_notes_file = "~/Documents/orgfiles/refile.org",
      -- Fold/Unfold Headlines
      mappings = {
        org = {
          -- org_cycle = false, -- unmap TAB
          -- org_global_cycle = false, -- unmap S-TAB
          org_cycle = "<leader>of",
          org_global_cycle = "<leader>oF",
        },
      },
      -- map("i", "<C-a>", "<Home>", { desc = "Home" })
      -- Custom todos
      org_todo_keywords = { "TODO", "WAITING", "|", "DONE", "DELEGATED" },
      org_todo_keyword_faces = {
        WAITING = ":foreground blue :weight bold",
        DELEGATED = ":background #FFFFFF :slant italic :underline on",
        TODO = ":background #000000 :foreground red", -- overrides builtin color for `TODO` keyword
      },
    })

    -- Experimental LSP support
    vim.lsp.enable("org")
  end,
}
