return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "elixir", "eex", "heex" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- official Elixir LSP: https://expert-lsp.org (`:MasonInstall expert`)
        expert = {},
      },
    },
  },
}
