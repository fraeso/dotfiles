return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "php", "blade" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 5000000,
              },
            },
          },
        },
      },
    },
  },
}
