return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  -- ponytail: lazy=false so setup runs at startup; keymaps live in
  -- config/keymaps.lua so they reliably override LazyVim's snacks `keys`
  -- (plugin-vs-plugin key specs race; config keymaps run last and win).
  lazy = false,
  opts = {},
}
