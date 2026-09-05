-- explorer sidebar widens to its longest rendered line
local function fit_explorer()
  local picker = require("snacks.picker").get({ source = "explorer" })[1]
  if not picker or not picker.list or not picker.list.win:valid() then
    return
  end

  local box
  for _, win in pairs(picker.layout.box_wins or {}) do
    if win:valid() then
      box = win.win
    end
  end
  if not box then
    return
  end

  local width = 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(picker.list.win.buf, 0, -1, false)) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(math.max(width + 2, 30), math.floor(vim.o.columns * 0.4))

  if vim.api.nvim_win_get_width(box) ~= width then
    vim.api.nvim_win_set_width(box, width)
    picker.layout:update()
  end
end

return {
  "folke/snacks.nvim",
  keys = {
    -- free these up for diffview.nvim (see plugins/diffview.lua)
    { "<leader>gd", false },
    { "<leader>gD", false },
  },
  opts = {

    animate = { enabled = true, fps = 120 }, -- shared animation engine; cap is your monitor's refresh rate
    indent = {
      enabled = true,
      indent = {
        char = "┊",
        -- rotating per level; groups defined in config() from the theme palette
        hl = {
          "SnacksIndent1",
          "SnacksIndent2",
          "SnacksIndent3",
          "SnacksIndent4",
          "SnacksIndent5",
          "SnacksIndent6",
        },
      },
      scope = {
        char = "┊",
        -- same rotation, at full strength
        hl = {
          "SnacksIndentScope1",
          "SnacksIndentScope2",
          "SnacksIndentScope3",
          "SnacksIndentScope4",
          "SnacksIndentScope5",
          "SnacksIndentScope6",
        },
      },
    },
    dim = { enabled = true }, -- animated scope dimming
    scroll = { enabled = true }, -- smooth scroll
    quickfile = { enabled = true }, -- renders the file before plugins finish loading; faster cold opens

    picker = {
      ui_select = true,
      layout = {
        preset = "vscode",
        preview = true,
        -- layout = {
        --   height = 0.5, -- ivy default is 0.4 (40% of screen); raise to bring it up further
        -- },
      }, -- picker pinned to the bottom edge, with preview
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
          -- no border override: the "bottom"/ivy preset draws a single bottom underline.
          -- a full box border (e.g. "rounded") gets clipped at the screen edges in this full-width layout.
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
              width = 40,
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    -- indent guides / whitespace dots, from whatever theme is loaded:
    -- six well-separated hues, faded toward the background for the inactive ones
    local hues = {
      "DiagnosticError",
      "DiagnosticWarn",
      "DiagnosticOk",
      "DiagnosticInfo",
      "DiagnosticHint",
      "Function",
    }

    local function tint()
      -- transparent themes leave Normal.bg unset; fade toward the terminal instead
      local bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        or (vim.o.background == "light" and 0xffffff or 0x000000)

      local function fade(fg, alpha)
        local channel = function(shift)
          local f = bit.band(bit.rshift(fg, shift), 255)
          local b = bit.band(bit.rshift(bg, shift), 255)
          return math.floor(f * alpha + b * (1 - alpha) + 0.5)
        end
        return channel(16) * 0x10000 + channel(8) * 0x100 + channel(0)
      end

      for i, group in ipairs(hues) do
        local fg = vim.api.nvim_get_hl(0, { name = group, link = false }).fg
        if fg then
          vim.api.nvim_set_hl(0, "SnacksIndent" .. i, { fg = fade(fg, 0.3) })
          vim.api.nvim_set_hl(0, "SnacksIndentScope" .. i, { fg = fg })
        end
      end

      local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false }).fg
      if comment then
        vim.api.nvim_set_hl(0, "Whitespace", { fg = fade(comment, 0.5) })
        vim.api.nvim_set_hl(0, "SnacksPickerTree", { fg = fade(comment, 0.5) })
      end
    end

    tint()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = tint })

    vim.api.nvim_create_autocmd({ "BufWinEnter", "TextChanged", "CursorMoved" }, {
      callback = function(ev)
        if vim.bo[ev.buf].filetype == "snacks_picker_list" then
          fit_explorer()
        end
      end,
    })
  end,
}
