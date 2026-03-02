return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Powerline Separators
    local powerline = {
      right = "\u{e0b0}",
      left = "\u{e0b2}",
      right_filled = "\u{e0b1}",
      left_filled = "\u{e0b3}",
    }

    -- Round Separators
    local round = {
      right = "\u{e0b4}",
      left = "\u{e0b6}",
      right_filled = "\u{e0b5}",
      left_filled = "\u{e0b7}",
    }

    -- Additional Separators
    local extra = {
      block = "\u{2588}",
      vertical = "\u{2502}",
      vertical_thick = "\u{2503}",
      right_triangle = "\u{e0ba}",
      left_triangle = "\u{e0bc}",
      right_semi = "\u{e0bb}",
      left_semi = "\u{e0bd}",
    }

    -- custom theme with transparent middle section
    -- themes:
    -- horizon, everforest, dracula, modus-vivendi, catppuccin, rose-pine, morta
    local custom = require("lualine.themes.vague") -- !!!change lualine theme here!!!
    local NO_BG = "NONE"
    -- custom.normal.c.bg = NO_BG
    -- custom.insert.c.bg = NO_BG
    -- custom.visual.c.bg = NO_BG
    -- custom.replace.c.bg = NO_BG
    -- custom.command.c.bg = NO_BG
    -- custom.inactive.c.bg = NO_BG

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = custom,
        component_separators = { left = round.right_filled, right = round.left_filled },
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
        section_separators = { left = round.right, right = round.left },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { { "mode", icon = "", separator = { left = round.left, right = round.right } } },
        lualine_b = {
          {
            "filename",
            icon = "",
            colored = true,
          },
          {
            "branch",
            icon = "",
            colored = true,
          },
        },

        -- center components
        lualine_c = {
          {
            "encoding",
            icon = " ",
            "filename",
            color = { bg = NO_BG },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_lsp" },
            sections = { "error", "warn" },
            always_visible = true,
          },
        },

        lualine_y = {
          {
            "filetype",
          },
          {
            "progress",
            icon = "󰲽",
          },
          { "location" },
        },
        lualine_z = {
          {
            function()
              return os.date("%H:%M:%S")
            end,
            separator = { right = round.right, left = round.left },
            icon = "󰃰",
          },
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},

      extensions = {},
    })
  end,
}
