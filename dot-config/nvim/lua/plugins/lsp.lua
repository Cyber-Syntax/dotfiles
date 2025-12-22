return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- marksman = {
        --   enabled = false, -- Attempt to disable marksman
        -- },
      },
      diagnostics = {
        underline = false,
        update_in_insert = true,
        virtual_text = false,
        float = {
          source = "always", -- show diagnostic source in float
          border = "rounded",
        },
      },
    },
  },
}
