-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Diagnostic styling that outlives the colorscheme. Each theme picks its own
-- diagnostic colours and we keep them; only the *shape* is ours — dots under the
-- offending token rather than a wavy line, and a dimmed italic for the message
-- half of the inline virtual text (the icon half keeps the severity colour).
local function diagnostic_style()
  for _, severity in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
    local group = "DiagnosticUnderline" .. severity
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.underline, hl.undercurl, hl.underdashed, hl.underdouble = nil, nil, nil, nil
    hl.underdotted = true
    hl.cterm = nil -- rebuilt from the gui attrs above
    vim.api.nvim_set_hl(0, group, hl)
  end

  -- dimmest readable foreground the theme offers, line numbers first
  local dim = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).fg
    or vim.api.nvim_get_hl(0, { name = "Comment", link = false }).fg
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextDim", { fg = dim, italic = true })
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = diagnostic_style })
diagnostic_style() -- autocmds load after the colorscheme is already applied
