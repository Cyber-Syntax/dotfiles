return {
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      -- For the magick_cli processor (default) you need a regular installation of ImageMagick.
      -- For the magick_rock processor you need to install the development version of ImageMagick.
      processor = "magick_cli",
    },
  },
}
