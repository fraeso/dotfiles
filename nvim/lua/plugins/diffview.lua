-- diffview.nvim — a clean, side-by-side diff & merge-conflict UI inside Neovim.
--
-- Two main uses:
--   1. Browsing changes: <leader>gd opens a tab with the file list on the left
--      and a two-column (old | new) diff on the right. <leader>gh shows history.
--   2. Resolving merge conflicts: during a merge/rebase with conflicts, open the
--      repo and run :DiffviewOpen (or git mergetool / lazygit's `M`, which are
--      wired to this via ~/.gitconfig). Each conflicted file shows a 3-way view:
--        OURS (local)  |  working result  |  THEIRS (incoming)
--      In the middle (result) buffer, with the cursor on a conflict:
--        <leader>co  take OURS        <leader>ct  take THEIRS
--        <leader>cb  take BASE        <leader>ca  take ALL
--        ]x / [x     next / prev conflict
--      Save + :DiffviewClose when done, then continue the merge in lazygit.
return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open (working tree)" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: current file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo history" },
    },
    opts = {
      enhanced_diff_hl = true, -- richer highlighting of intra-line changes
      view = {
        -- 3-way merge layout: OURS | result | THEIRS, laid out horizontally.
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true, -- LSP errors are noise mid-conflict
        },
      },
    },
  },
}
