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

    -- true when the current buffer is backed by a real (named) file
    local function has_file()
      return vim.api.nvim_buf_get_name(0) ~= ""
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
            icon = "\u{f0633}", -- \udb82\udfc9
            separator = { left = round.left, right = round.right },
            padding = { left = 0, right = 1 },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "\u{f126}", --
            -- cap displayed branch name at 24 chars (incl. the ellipsis)
            fmt = function(name)
              if #name > 24 then
                return name:sub(1, 21) .. "..."
              end
              return name
            end,
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
          -- real file: relative path. file_status is off so lualine never appends
          -- the modified/readonly block (and its stray space) — dirty state lives on
          -- the bufferline tab; the readonly lock is its own component below.
          {
            "filename",
            path = 1, -- relative path
            file_status = false,
            color = { bg = NO_BG },
            cond = has_file,
          },
          -- readonly lock, only when the buffer can't be edited
          {
            function()
              return "\u{f023}" --
            end,
            cond = function()
              return has_file() and (vim.bo.readonly or not vim.bo.modifiable)
            end,
            color = { bg = NO_BG },
            padding = { left = 0, right = 1 },
          },
          -- real file: filetype icon
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 0, right = 1 },
            cond = has_file,
          },
          -- no file open: a single minimal glyph, nothing else
          {
            function()
              return "\u{f02a0}" -- 󰊠 (ghost)
            end,
            cond = function()
              return not has_file()
            end,
            color = { bg = NO_BG },
          },
        },
        lualine_x = {},

        lualine_y = {
          { "encoding", icon = "\u{f121} " }, --
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            always_visible = false,
            symbols = {
              error = "\u{f06a} ", --
              warn = "\u{f071} ", --
              info = "\u{ea74} ", --
              hint = "\u{f0eb} ", --
            },
          },
        },
        lualine_z = {
          {
            -- active LSP server(s) attached to the current buffer, with a
            -- fallback icon when nothing is attached
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then
                return "\u{f127} " --  (no LSP attached)
              end
              local names = {}
              for _, client in ipairs(clients) do
                names[#names + 1] = client.name
              end
              return "\u{f013} " .. table.concat(names, ", ") --
            end,
            separator = { right = round.right, left = round.left },
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
