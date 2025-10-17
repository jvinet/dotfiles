return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- moon, storm, night, day
      style = "moon",
      on_colors = function(colors)
        colors.border = colors.dark5
      end,
      on_highlights = function(highlights, colors)
        highlights.Normal = { fg = colors.fg, bg = colors.bg }
        -- Set inactive windows to a slightly darker colour.
        highlights.NormalNC = { fg = colors.fg, bg = colors.bg_dark }
      end,
    },
  },
}
