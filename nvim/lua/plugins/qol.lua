-- Small quality-of-life plugins grouped in one file to keep plugins/ tidy.
-- lazy.nvim accepts a list of specs from a single file, so each entry below
-- is its own plugin. Comment headers explain what each one is for.
return {
  -- mini.surround — add/delete/replace surrounding pairs (quotes, brackets, tags).
  -- e.g. `saiw)` surround-add inner word with parens, `sd"` delete surrounding quotes.
  {
    "nvim-mini/mini.surround",
    opts = {},
  },

  -- vim-sleuth — auto-detect indentation (shiftwidth/expandtab) per file/project.
  -- {
  --   "tpope/vim-sleuth",
  -- },
  {
    "nmac427/guess-indent.nvim",
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
