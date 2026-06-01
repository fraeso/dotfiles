return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.opt.termguicolors = true

    require("bufferline").setup({
      highlights = {
        fill = { bg = "none" },
        background = { bg = "none" },
        buffer_selected = { bg = "none", bold = true, italic = false },
        buffer_visible = { bg = "none" },
        separator = { bg = "none" },
        separator_selected = { bg = "none" },
        separator_visible = { bg = "none" },
        indicator_selected = { bg = "none" },
      },
      options = {
        separator_style = "thin", -- "slant", "padded_slant", "thin"
        indicator = { style = "none" },
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
            bg = "none",
          },
        },
      },
    })
  end,
}
