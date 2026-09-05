return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = {
        virtual_text = true,
        virtual_lines = false,
      },
    },
    -- end-of-line diagnostics with a coloured icon and a dim message; the
    -- built-in handler paints both with one highlight group, so it's replaced
    init = function()
      local icons = { "■", "▲", "◆", "●" } -- ERROR, WARN, INFO, HINT
      local groups = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
      local nss = setmetatable({}, {
        __index = function(t, k)
          local ns = vim.api.nvim_create_namespace("cendre_diag_vt_" .. k)
          rawset(t, k, ns)
          return ns
        end,
      })

      vim.diagnostic.handlers.virtual_text = {
        show = function(namespace, bufnr, diagnostics, _)
          if not vim.api.nvim_buf_is_loaded(bufnr) then
            return
          end
          local ns = nss[namespace]
          vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
          -- worst severity per line; async diagnostics can outlive their lines
          local last = vim.api.nvim_buf_line_count(bufnr) - 1
          local worst = {}
          for _, d in ipairs(diagnostics) do
            local cur = worst[d.lnum]
            if d.lnum <= last and (not cur or d.severity < cur.severity) then
              worst[d.lnum] = d
            end
          end
          for lnum, d in pairs(worst) do
            vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
              virt_text = {
                { "    " .. icons[d.severity] .. " ", groups[d.severity] },
                { d.message:gsub("%s*\n%s*", " "), "DiagnosticVirtualTextDim" },
              },
              virt_text_pos = "eol",
              hl_mode = "combine",
            })
          end
        end,
        hide = function(namespace, bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_clear_namespace(bufnr, nss[namespace], 0, -1)
          end
        end,
      }
    end,
  },

  -- `gs` prefix so flash.nvim keeps `s` for its jump motion
  {
    "nvim-mini/mini.surround",
    -- Lazy-load on first use of any surround key. Without this the plugin never
    -- loads at startup (LazyVim defaults plugins to lazy), so the mappings below
    -- never register and nothing gets surrounded.
    keys = {
      { "gsa", mode = { "n", "x" }, desc = "Add surrounding" },
      { "gsd", desc = "Delete surrounding" },
      { "gsr", desc = "Replace surrounding" },
      { "gsf", desc = "Find surrounding (right)" },
      { "gsF", desc = "Find surrounding (left)" },
      { "gsh", desc = "Highlight surrounding" },
      { "gsn", desc = "Update n_lines" },
    },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  {
    "nmac427/guess-indent.nvim",
    lazy = false,
    config = function()
      require("guess-indent").setup({})
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },

  {
    "nvim-mini/mini.diff",
    opts = {
      view = {
        style = "sign",
        signs = {
          add = "▎",
          change = "▎",
          delete = "▁",
        },
        priority = 199,
      },
      options = {
        algorithm = "histogram",
        indent_heuristic = true,
        linematch = 60,
      },
    },
    keys = {
      {
        "<leader>go",
        function()
          require("mini.diff").toggle_overlay()
        end,
        desc = "Toggle git diff overlay (line numbers)",
      },
    },
  },

  {
    "b0o/incline.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      highlight = {
        groups = {
          InclineNormal = "Visual",
          InclineNormalNC = "Visual",
        },
      },
    },
  },
}
