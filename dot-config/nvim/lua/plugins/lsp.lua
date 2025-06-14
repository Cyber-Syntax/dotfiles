return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        --FIX: Those are not working for the current diagnostic shows
        -- seems like something else is handle the floating and underline diagnostics
        underline = false,
        float = {
          source = false,
        },
        --NOTE: this will disable the text diagnostics text to the line of the line
        -- But this was showing for all the lines even if your cursor is not in that line.
        -- This is still not prevent to show the diagnostics in the floating window or underline.
        virtual_text = false,
      },
    },
  },
}
