return {
  { import = "lazyvim.plugins.extras.lang.git" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.editor.harpoon2" },
  { import = "lazyvim.plugins.extras.editor.mini-diff" },
  { import = "lazyvim.plugins.extras.ai.copilot-chat" },
  -- octo github integration, able to comment isue, send PR
  { import = "lazyvim.plugins.extras.util.octo" },
  { import = "lazyvim.plugins.extras.util.dot" },
  -- NOTE: This make class, function, try:, if command is seen on the top of the file
  -- It would helpful for: "am I on the try block or if block, am I on the folder class or zip class"
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  --FIX: prettier cause formatting issues on .jsonc files
  -- { import = "lazyvim.plugins.extras.formatting.prettier" },
}
