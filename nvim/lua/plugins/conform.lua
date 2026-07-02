return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = false,
    formatters_by_ft = {
      go = { "gofumpt" },
      java = { "google-java-format" },
      xml = { "xmllint" },
      markdown = { "markdownlint-cli2", "markdown-toc" },
    },
  },
}
