-- diffview names panes "INDEX"/"WORKING TREE"; say old/new instead
local function relabel_panes()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local winbar = vim.wo[win].winbar
    -- fires on more than one event; don't relabel what's already labelled
    if winbar ~= "" and not winbar:find("^%u+ ·") then
      if winbar:find("WORKING TREE") then
        vim.wo[win].winbar = winbar:gsub("^%s*WORKING TREE %- ", "AFTER · on disk  ")
      elseif winbar:find("INDEX") then
        vim.wo[win].winbar = winbar:gsub("^%s*INDEX %-?%s*", "BEFORE · staged  "):gsub(":0:", "")
      else
        -- " <sha>:path" when diffing against a commit
        vim.wo[win].winbar = winbar:gsub("^%s*(%w+):", "BEFORE · %1  ")
      end
    end
  end
end

-- file panel widens to its longest rendered line
local function fit_panel(win)
  local width = 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(win), 0, -1, false)) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(math.max(width + 2, 35), math.floor(vim.o.columns * 0.4))
  if vim.api.nvim_win_get_width(win) ~= width then
    vim.api.nvim_win_set_width(win, width)
  end
end

return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" },
    { "<leader>gD", "<cmd>DiffviewOpen origin<cr>", desc = "Diff View (origin)" },
    -- <leader>gf is overridden in config/keymaps.lua (LazyVim sets it globally on VeryLazy)
  },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  opts = {
    view = {
      -- name each pane in its winbar: "WORKING TREE" vs the commit it's diffed against
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    },
    keymaps = {
      -- q closes diffview from any of its panels
      view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
      file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
      file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
    },
  },
  config = function(_, opts)
    require("diffview").setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = { "DiffviewDiffBufWinEnter", "DiffviewViewPostLayout" },
      callback = relabel_panes,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "DiffviewFiles", "DiffviewFileHistory" },
      callback = function(ev)
        -- the panel paints its own background; follow the terminal instead
        vim.api.nvim_set_hl(0, "DiffviewNormal", { link = "Normal" })
        vim.api.nvim_set_hl(0, "DiffviewEndOfBuffer", { link = "EndOfBuffer" })

        vim.api.nvim_create_autocmd({ "BufWinEnter", "TextChanged", "CursorMoved" }, {
          buffer = ev.buf,
          callback = function()
            local win = vim.fn.bufwinid(ev.buf)
            if win ~= -1 then
              fit_panel(win)
            end
          end,
        })
      end,
    })
  end,
}
