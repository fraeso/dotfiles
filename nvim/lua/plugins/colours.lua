local theme = "vague"

return {
  {
    "vague-theme/vague.nvim",
    enabled = theme == "vague",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other plugins
    config = function()
      require("vague").setup({
        transparent = true
      })
      vim.cmd("colorscheme vague")
    end,
  },
}
