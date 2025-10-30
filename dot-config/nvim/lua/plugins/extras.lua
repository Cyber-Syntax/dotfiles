return {
  -- LANGUAGE EXTRAS
  { import = "lazyvim.plugins.extras.lang.git" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  -- { import = "lazyvim.plugins.extras.lang.ansible" },

  -- UI EXTRAS
  -- NOTE: This make class, function, try:, if command is seen on the top of the file
  -- It would helpful for: "am I on the try block or if block, am I on the folder class or zip class"
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  { import = "lazyvim.plugins.extras.ui.indent-blankline" },
  -- { import = "lazyvim.plugins.extras.ui.edgy" },

  -- EDITOR EXTRAS
  -- fast file navigation
  { import = "lazyvim.plugins.extras.editor.harpoon2" },
  -- highlight same words under cursor
  { import = "lazyvim.plugins.extras.editor.illuminate" },
  -- show the outline of the file like headings on markdown, class, function etc.
  { import = "lazyvim.plugins.extras.editor.outline" },
  -- { import = "lazyvim.plugins.extras.editor.neo-tree" },
  -- { import = "lazyvim.plugins.extras.editor.mini-diff" },

  -- UTILITIES EXTRAS
  -- octo github integration, able to comment isue, send PR
  { import = "lazyvim.plugins.extras.util.octo" },

  -- AI EXTRAS
  -- { import = "lazyvim.plugins.extras.ai.copilot-chat" },
  { import = "lazyvim.plugins.extras.ai.avante" },

  --FIX: prettier cause formatting issues on .jsonc files
  -- { import = "lazyvim.plugins.extras.formatting.prettier" },
}
