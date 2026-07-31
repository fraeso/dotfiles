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
    -- pills at both ends (z left unset so lualine mirrors it onto a), the theme's
    -- secondary ground on b and y, nothing behind the middle
    local base = custom.normal or {}
    local quiet = base.c and base.c.fg or nil
    local second = { fg = base.b and base.b.fg or quiet, bg = base.b and base.b.bg or nil }
    for _, mode in pairs(custom) do
      if mode.c then
        mode.c.bg = NO_BG
      end
      mode.x = { fg = quiet, bg = NO_BG }
      mode.y = vim.deepcopy(second)
    end

    -- mini.diff counts, one colour each via inline %#Group#
    local diff_marks = {
      { "delete", "■", "DiagnosticError" },
      { "change", "▲", "DiagnosticWarn" },
      { "add", "◆", "DiagnosticInfo" },
    }

    local function has_file()
      return vim.api.nvim_buf_get_name(0) ~= ""
    end

    local function gitdiff()
      local counts = vim.b.minidiff_summary or {}
      local parts = {}
      for _, mark in ipairs(diff_marks) do
        parts[#parts + 1] = ("%%#%s#%s %d"):format(mark[3], mark[2], counts[mark[1]] or 0)
      end
      return table.concat(parts, " ")
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
            icon = "\u{f0633}", -- 󰘳
            separator = { left = round.left, right = round.right },
            padding = { left = 0, right = 1 },
          },
        },
        lualine_b = {
          { "filename", path = 0, file_status = false, cond = has_file, padding = { left = 2, right = 1 } },
          {
            function()
              return "\u{f02a0}" -- ghost
            end,
            cond = function()
              return not has_file()
            end,
            padding = { left = 2, right = 1 },
          },
        },

        lualine_c = {
          {
            "branch",
            icon = "\u{f126}",
            -- cap displayed branch name at 24 chars (incl. the ellipsis)
            fmt = function(name)
              if #name > 24 then
                return name:sub(1, 21) .. "..."
              end
              return name
            end,
          },
        },
        lualine_x = { gitdiff },
        lualine_y = {
          { "filetype", icons_enabled = false, separator = "", padding = { left = 1, right = 2 } },
        },
        lualine_z = {
          {
            "location",
            separator = { left = round.left, right = round.right },
            padding = { left = 1, right = 1 },
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
