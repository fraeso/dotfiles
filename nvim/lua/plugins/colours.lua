return {
  { "LazyVim/LazyVim", opts = { colorscheme = "vague" } },

  -- installed themes
  {
    "vague-theme/vague.nvim",
    lazy = false,
    priority = 1000,
    opts = { transparent = true },
  },
}
