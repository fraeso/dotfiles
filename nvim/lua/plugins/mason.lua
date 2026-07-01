-- Preserve hand-installed tools that no enabled LazyVim extra declares, so a
-- fresh machine re-installs them automatically. Appended to LazyVim's list via
-- mason.nvim's `opts_extend = { "ensure_installed" }`.
return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      "gopls",
      "gofumpt",
      "golangci-lint",
      "rust-analyzer",
      "typescript-language-server",
      "css-lsp",
    },
  },
}
