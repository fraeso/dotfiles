return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  config = function()
    local transparent = require("transparent")
    transparent.setup({
      -- extra highlight groups to clear, if some plugin's bg leaks through
      extra_groups = {
        "NormalFloat", -- floating windows (lsp hover, etc.)
        "NvimTreeNormal",
        "Pmenu", -- builtin popup menu / wildmenu
        "PmenuSel",
      },
      exclude_groups = {}, -- groups you want to KEEP a background on
    })
    -- Clear every highlight under a plugin's prefix at once.
    -- These re-apply automatically when the colorscheme changes.
    transparent.clear_prefix("BufferLine") -- bufferline tabs
    transparent.clear_prefix("BlinkCmp") -- blink.cmp completion menu
    transparent.clear_prefix("Noice") -- noice cmdline / command popup
    -- NOTE: lualine transparency is handled at the theme source in lualine.lua,
    -- not here — its separator highlights are created lazily and would re-leak
    -- whenever a new statusline state is drawn (e.g. opening snacks picker).
    vim.g.transparent_enabled = true -- on by default; toggle with :TransparentToggle
  end,
}
