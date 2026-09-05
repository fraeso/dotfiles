return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      max_name_length = 24,
      truncate_names = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      diagnostics = true,
      always_show_bufferline = true,
      indicator = { style = "underline" },
      separator_style = { "", "" },
    },
    highlights = {
      buffer_selected = { italic = false },
    },
  },
}
