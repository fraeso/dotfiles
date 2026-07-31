-- Small quality-of-life plugins grouped in one file to keep plugins/ tidy.
-- lazy.nvim accepts a list of specs from a single file, so each entry below
-- is its own plugin. Comment headers explain what each one is for.
return {
  -- Inline diagnostics. Must go through LazyVim's `diagnostics` opts — LazyVim
  -- calls vim.diagnostic.config() in nvim-lspconfig's config(), which runs after
  -- VeryLazy and would clobber a plain autocmd.
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = true, -- message to the right of the code (handler below)
        virtual_lines = false, -- no wrapped message block under the line
      },
    },
    init = function()
      -- Two-tone end-of-line diagnostics, cendre-style: a severity-coloured icon
      -- followed by the message in quiet italic. The built-in virtual_text handler
      -- paints icon and message with one highlight group, so it can't do this —
      -- hence the replacement. One extmark namespace per diagnostic namespace, or
      -- two LSPs on the same buffer would clear each other's marks.
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
          -- one message per line: the most severe (severity 1 = ERROR). Lines past
          -- the end of the buffer are dropped — diagnostics arrive asynchronously
          -- and can outlive the lines they were computed against.
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

  -- mini.surround — add/delete/replace surrounding pairs (quotes, brackets, tags).
  -- Remapped to a `gs` prefix so flash.nvim can keep `s` for its jump motion:
  -- `gsaiw)` surround-add inner word with parens, `gsd"` delete surrounding quotes,
  -- `gsr"'` replace surrounding " with '. In visual mode: select then `gsa*`.
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

  -- vim-sleuth — auto-detect indentation (shiftwidth/expandtab) per file/project.
  -- {
  --   "tpope/vim-sleuth",
  -- },
  {
    "nmac427/guess-indent.nvim",
    lazy = false,
    config = function()
      require("guess-indent").setup({})
    end,
  },

  -- vim-tmux-navigator — move seamlessly between nvim splits and tmux panes
  -- with <c-h/j/k/l> (and <c-\> for the previous pane).
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

  -- noice — replaces the cmdline/messages UI. Here only used to add a border to
  -- LSP hover docs and signature help.
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },

  -- mini.diff — git diff signs in the gutter, plus an inline overlay.
  -- <leader>go toggles the overlay (colors line numbers + word-level diff);
  -- the default 'sign' view shows gutter bars only.
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
}
