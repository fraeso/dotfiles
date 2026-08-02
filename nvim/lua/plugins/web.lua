return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css", "scss" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        emmet_language_server = {},
        somesass_ls = {},
        cssls = {
          settings = {
            -- tailwind's at-rules aren't in cssls's vocabulary
            css = { lint = { unknownAtRules = "ignore" } },
            scss = { lint = { unknownAtRules = "ignore" } },
            less = { lint = { unknownAtRules = "ignore" } },
          },
        },
      },
    },
  },
}
