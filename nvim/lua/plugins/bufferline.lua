return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.opt.termguicolors = true

    -- Colours read off the live colorscheme rather than pinned, so a theme
    -- switch carries the bar with it. `Special` is the accent in most themes
    -- (ember, in cendre) and `Comment` the dimmest readable foreground.
    local function from(group)
      return { attribute = "fg", highlight = group }
    end
    local accent, dim, ink = from("Special"), from("Comment"), from("Normal")

    -- Only the active tab is marked: the name at full strength with an accent
    -- rule under it. Every *_selected group repeats the underline, or the rule
    -- breaks wherever bufferline switches highlight mid-tab.
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
        separator_style = { "", "" }, -- no dividers between tabs
        indicator = { style = "underline" },

        -- Tabs size to their name. `tab_size` is a *minimum* width that
        -- bufferline pads shorter tabs up to, split evenly across both sides —
        -- that was the ____filename____ gap, and the reason the rule ran wide.
        tab_size = 0,
        -- A tab is built as: indicator, name, space, modified marker, space
        -- (ui.lua:485) — one cell of lead against three of trail, which is why
        -- the name sat left of centre. Two more on the left evens it up.
        name_formatter = function(buf)
          return "  " .. buf.name
        end,
        -- and with close icons off, bufferline adds the icon's width back onto
        -- the left as compensation. Emptying the icon makes that zero.
        show_buffer_close_icons = false,
        buffer_close_icon = "",
        show_close_icon = false,

        -- Names, nothing else: no filetype icon (that was the blue/orange) and
        -- no diagnostic tinting, which recoloured a whole tab on a stray hint.
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
