return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = false,
        update_in_insert = true,
        virtual_text = false,
        float = {
          source = "always", -- show diagnostic source in float
          border = "rounded",
        },
      },
      -- setup = {
      --   -- hook after LSP attach
      --   ---@param _ string
      --   ---@param bufnr number
      --   on_attach = function(_, bufnr)
      --     -- auto open diagnostics on CursorHold
      --     vim.api.nvim_create_autocmd("CursorHold", {
      --       buffer = bufnr,
      --       callback = function()
      --         vim.diagnostic.open_float(nil, {
      --           focusable = false,
      --           border = "rounded",
      --           scope = "line",
      --           source = "always",
      --         })
      --       end,
      --     })
      --   end,
      -- },
    },
  },
}
