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
    local custom = require("lualine.themes.auto") -- follows whatever colorscheme is active
    local NO_BG = "NONE"
    -- Make the middle sections (c, x, y) transparent for ANY lualine theme.
    -- Done at the theme SOURCE so lualine's lazily-created separator/transitional
    -- highlights inherit NONE too. transparent.nvim can't fix those because they're
    -- minted on-demand (e.g. when snacks picker opens) without firing ColorScheme.
    for _, mode in pairs(custom) do
      for _, section in ipairs({ "c", "x", "y" }) do
        if mode[section] then
          mode[section].bg = NO_BG
        end
      end
    end

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = custom,
        component_separators = "", -- no inner dividers -> cleaner, more minimal
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
        lualine_a = {
          {
            "mode",
            icon = "\u{f0e7}", --  (lightning)
            separator = { left = round.left, right = round.right },
            padding = { left = 0, right = 1 },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "\u{f126}", --
          },
          {
            "diff",
            colored = false, -- use the section's theme color instead of green/orange/red
            symbols = {
              added = "\u{f0fe} ", --
              modified = "\u{f111} ", --
              removed = "\u{f146} ", --
            },
          },
        },

        -- center components (transparent)
        lualine_c = {
          {
            "filename",
            path = 1, -- relative path
            symbols = { modified = " \u{f111}", readonly = " \u{f023}" }, --  /
            color = { bg = NO_BG },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 0, right = 1 } },
        },
        lualine_x = {},

        lualine_y = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            always_visible = true,
            symbols = {
              error = "\u{f06a} ", --
              warn = "\u{f071} ", --
              info = "\u{f05a} ", --
              hint = "\u{f0eb} ", --
            },
          },
        },
        lualine_z = {
          {
            -- active LSP server(s) attached to the current buffer
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                names[#names + 1] = client.name
              end
              return table.concat(names, ", ")
            end,
            icon = "\u{f085}", --
          },
          {
            function()
              return os.date("%H:%M")
            end,
            separator = { right = round.right, left = round.left },
            icon = "\u{f017}", --
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
