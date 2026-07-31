return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.opt.termguicolors = true

    local function from(group)
      return { attribute = "fg", highlight = group }
    end
    local accent, dim, ink = from("Special"), from("Comment"), from("Normal")

    -- every *_selected group repeats the underline, or the rule breaks apart
    local selected = { bg = "none", fg = ink, sp = accent, underline = true, bold = true, italic = false }

    require("bufferline").setup({
      highlights = {
        fill = { bg = "none" },
        background = { bg = "none", fg = dim },
        buffer_visible = { bg = "none", fg = dim },
        buffer_selected = selected,
        modified = { bg = "none", fg = dim },
        modified_visible = { bg = "none", fg = dim },
        modified_selected = vim.tbl_extend("force", selected, { fg = accent }),
        duplicate = { bg = "none", fg = dim, italic = false },
        duplicate_visible = { bg = "none", fg = dim, italic = false },
        duplicate_selected = selected,
        indicator_selected = { bg = "none", fg = accent, sp = accent, underline = true },
      },
      options = {
        separator_style = { "", "" },
        indicator = { style = "underline" },

        tab_size = 0, -- minimum width, padded evenly onto both sides
        name_formatter = function(buf)
          return "  " .. buf.name -- offsets the modified marker's trailing space
        end,
        show_buffer_close_icons = false,
        buffer_close_icon = "", -- hidden icons still reserve their width
        show_close_icon = false,

        show_buffer_icons = false,
        diagnostics = false,

        always_show_bufferline = true,
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
