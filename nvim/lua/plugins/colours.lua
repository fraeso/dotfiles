return {
  { "LazyVim/LazyVim", opts = { colorscheme = "cendre" } },

  -- installed themes
  {
    "vague-theme/vague.nvim",
    lazy = false,
    priority = 1000,
    opts = { transparent = true },
  },
  {
    "Aejkatappaja/cendre",
    lazy = false,
    priority = 1000,
    config = function()
      require("cendre").setup({
        background = "hard", -- "hard" | "medium" | "soft"
        italic = true,
        transparent = true,
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "cendre",
        callback = function()
          for _, g in ipairs({
            "BlinkCmpMenu",
            "BlinkCmpMenuBorder",
            "BlinkCmpScrollBarGutter",
            "BlinkCmpDoc",
            "BlinkCmpDocBorder",
            "BlinkCmpSignatureHelp",
            "BlinkCmpSignatureHelpBorder",
          }) do
            vim.api.nvim_set_hl(0, g, { fg = vim.api.nvim_get_hl(0, { name = g }).fg })
          end
        end,
      })
    end,
  }
}
