return {
  "folke/snacks.nvim",
  opts = {

    animate = { enabled = false, fps = 120 }, -- shared animation engine; cap is your monitor's refresh rate
    indent = { enabled = false }, -- animated indent scope
    dim = { enabled = false }, -- animated scope dimming
    scroll = { enabled = true }, -- smooth scroll
    quickfile = { enabled = true }, -- renders the file before plugins finish loading; faster cold opens

    picker = {
      prompt = " ", -- icon shown before your typed text (default is "  ")
      ui_select = true,
      formatters = {
        file = {
          filename_first = true, -- show "foo.lua  src/path/" instead of "src/path/foo.lua" — scan filenames first
        },
      },
      matcher = {
        frecency = true, -- boost files you open often/recently to the top of results
      },
      win = {
        input = {
          border = "rounded", -- none | single | double | rounded | solid | shadow
          title = " Search ",
          title_pos = "center", -- left | center | right
          height = 1,
          wo = { winhighlight = "Normal:Normal,FloatBorder:FloatBorder" },
        },
      },
      sources = {
        explorer = {
          layout = {
            -- sidebar    — file-tree style pinned to the side
            -- ivy        — bottom split, input on top, preview on right
            -- ivy_split  — ivy variant with preview as a separate split
            -- dropdown   — centered, input on top, list below, no preview
            -- default    — input on top, list below, preview on the right
            -- telescope  — list on top, input below, preview on the right
            -- vertical   — input/list/preview stacked, centered
            -- vscode     — compact, no preview by default
            -- select     — small modal-style dialog, no preview
            -- left / right         — sidebar pinned to that edge
            -- top / bottom         — picker pinned to that edge
            preset = "sidebar",
            preview = false, -- true, false, or "main" to render preview in the main editor window
            layout = {
              position = "right",
              width = 60,
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}
