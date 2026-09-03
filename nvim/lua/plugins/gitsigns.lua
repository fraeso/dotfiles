return {
  -- the mini-diff extra disables gitsigns; re-enabled here for the blame line only
  "lewis6991/gitsigns.nvim",
  enabled = true,
  event = "LazyFile",
  opts = {
    signcolumn = false, -- mini.diff owns the gutter
    current_line_blame = true,
    current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
  },
  keys = {
    {
      "<leader>ub",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      desc = "Toggle blame line",
    },
  },
}
