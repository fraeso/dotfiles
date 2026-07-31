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
    -- Every section but the mode block sits straight on the bar: one slab of
    -- colour, everything else floating on the ground behind it.
    local quiet = custom.normal and custom.normal.c and custom.normal.c.fg or nil
    for _, mode in pairs(custom) do
      for _, section in ipairs({ "b", "c" }) do
        if mode[section] then
          mode[section].bg = NO_BG
        end
      end
      -- x/y/z are absent from most themes, and lualine then mirrors them onto
      -- c/b/a. `a` is the mode slab, whose foreground is the background colour —
      -- with the slab stripped, the right end of the bar would be near-black text
      -- on near-black ground. Pin all three to the quiet middle foreground.
      for _, section in ipairs({ "x", "y", "z" }) do
        mode[section] = { fg = mode[section] and mode[section].fg or quiet, bg = NO_BG }
      end
    end

    -- Git diff counts, in the order and marks the theme uses: deletions,
    -- modifications, additions. Written by hand rather than with lualine's
    -- `diff` component because that one is fixed at added/modified/removed and
    -- paints all three one colour. `%#Group#` switches highlight mid-component,
    -- so each count carries its own semantic colour.
    --
    -- Counts come from mini.diff (the LazyVim `editor.mini-diff` extra, which
    -- disables gitsigns) — hence `vim.b.minidiff_summary`, not the gitsigns dict.
    local diff_marks = {
      { "delete", "■", "DiagnosticError" },
      { "change", "▲", "DiagnosticWarn" },
      { "add", "◆", "DiagnosticInfo" },
    }

    -- All three are always on the bar, zeros included, so the right end of the
    -- statusline keeps a fixed width and the marks stay where the eye left them.
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
        -- flat blocks, no powerline caps: the mode reads as a solid slab of ember
        -- against the bar, which is the cendre statusline. Swap back to
        -- `{ left = round.right, right = round.left }` for the rounded version.
        section_separators = { left = "", right = "" },
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
            padding = { left = 2, right = 2 },
          },
        },
        -- name, then branch when the file is in a repo. No path, no icons: the
        -- bufferline already says which buffer this is.
        lualine_b = {
          { "filename", path = 0, file_status = false },
          {
            "branch",
            icon = "",
            -- cap displayed branch name at 24 chars (incl. the ellipsis)
            fmt = function(name)
              if #name > 24 then
                return name:sub(1, 21) .. "..."
              end
              return name
            end,
          },
        },

        -- the gap
        lualine_c = {},

        lualine_x = { gitdiff },
        lualine_y = {
          -- language, as plain text: "go", not an icon
          { "filetype", icons_enabled = false },
        },
        lualine_z = {
          { "location", padding = { left = 1, right = 2 } },
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
