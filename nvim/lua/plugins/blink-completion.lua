return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    }
    opts.keymap = {
      preset = "default",
      ["<Tab>"] = { "accept", "fallback" },
    }
    opts.appearance = {
      use_nvim_cmp_as_default = true,
    }
    opts.completion = {
      menu = {
        auto_show = true,
        border = "rounded",
        winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        scrollbar = true,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        treesitter_highlighting = true,
        window = {
          border = "rounded",
          min_width = 10,
          max_width = 80,
          max_height = 30,
          scrollbar = true,
        },
      },
    }
    return opts
  end,
  config = function(_, opts)
    -- Ensure sources.compat is removed
    if opts.sources and opts.sources.compat then
      opts.sources.compat = nil
    end

    require("blink.cmp").setup(opts)

    -- Note: Color/style configurations have been moved to the xcodedark theme
    -- They will be automatically applied when the xcodedark theme is loaded
  end,
}
