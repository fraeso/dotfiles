-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- keep each theme's diagnostic colours, override only the shape
local function diagnostic_style()
  for _, severity in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
    local group = "DiagnosticUnderline" .. severity
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.underline, hl.undercurl, hl.underdashed, hl.underdouble = nil, nil, nil, nil
    hl.underdotted = true
    hl.cterm = nil
    vim.api.nvim_set_hl(0, group, hl)
  end

  local dim = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).fg
    or vim.api.nvim_get_hl(0, { name = "Comment", link = false }).fg
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextDim", { fg = dim, italic = true })
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = diagnostic_style })
diagnostic_style() -- autocmds load after the colorscheme is already applied
