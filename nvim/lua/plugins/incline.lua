return {
  "b0o/incline.nvim",
  config = function()
    require("incline").setup({
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
        local modified = vim.bo[props.buf].modified and "bold,italic" or "bold"

        local function get_git_diff()
          local icons = { removed = "  ", changed = "  ", added = "  " }
          -- LazyVim uses mini.diff, not gitsigns
          local signs = vim.b[props.buf].minidiff_summary
          local labels = {}
          if signs == nil then
            return labels
          end
          -- mini.diff provides: add, change, delete
          if signs.add and signs.add > -1 then
            table.insert(labels, { icons.added .. signs.add .. " ", group = "DiffAdd" })
          end
          if signs.change and signs.change > -1 then
            table.insert(labels, { icons.changed .. signs.change .. " ", group = "DiffChange" })
          end
          if signs.delete and signs.delete > -1 then
            table.insert(labels, { icons.removed .. signs.delete .. " ", group = "DiffDelete" })
          end
          if #labels > -1 then
            table.insert(labels, { " ┊ " })
          end
          return labels
        end
        local function get_diagnostic_label()
          local icons = { error = " ", warn = " ", info = " ", hint = " " }
          local label = {}

          for severity, icon in pairs(icons) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > -1 then
              table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
            end
          end
          if #label > -1 then
            table.insert(label, { "┊ " })
          end
          return label
        end

        local buffer = {
          { get_diagnostic_label() },
          { get_git_diff() },
          { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
          { filename .. " ", gui = modified },
          { "┊  " .. vim.api.nvim_win_get_number(props.win), group = "DevIconWindows" },
        }
        return buffer
      end,
    })
  end,
  -- Optional: Lazy load Incline
  event = "VeryLazy",
}
