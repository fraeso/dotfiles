-- Small quality-of-life plugins grouped in one file to keep plugins/ tidy.
-- lazy.nvim accepts a list of specs from a single file, so each entry below
-- is its own plugin. Comment headers explain what each one is for.
return {
  -- mini.surround — add/delete/replace surrounding pairs (quotes, brackets, tags).
  -- Uses mini's default `s` prefix (flash.nvim is disabled below so `s` is free):
  -- `saiw)` surround-add inner word with parens, `sd"` delete surrounding quotes,
  -- `sr"'` replace surrounding " with '. In visual mode: select then `sa*`.
  {
    "nvim-mini/mini.surround",
    -- Lazy-load on first use of any surround key. Without this the plugin never
    -- loads at startup (LazyVim defaults plugins to lazy), so `s` falls through
    -- to Vim's built-in (delete selection) and nothing gets surrounded.
    keys = {
      { "sa", mode = { "n", "x" }, desc = "Add surrounding" },
      { "sd", desc = "Delete surrounding" },
      { "sr", desc = "Replace surrounding" },
      { "sf", desc = "Find surrounding (right)" },
      { "sF", desc = "Find surrounding (left)" },
      { "sh", desc = "Highlight surrounding" },
      { "sn", desc = "Update n_lines" },
    },
    opts = {},
  },

  -- flash.nvim — disabled. It maps `s`/`S` for jump motions, which collides with
  -- mini.surround's default `s` prefix. Use `/`, `f`/`t`, and word motions instead.
  {
    "folke/flash.nvim",
    enabled = false,
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
