-- CSS/SCSS: cssls for diagnostics + general CSS, somesass_ls for cross-file
-- SCSS $variable/@mixin completion. LazyVim auto-installs both via mason.
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      cssls = {},
      somesass_ls = {},
    },
  },
}
