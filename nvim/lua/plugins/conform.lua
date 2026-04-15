return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = false,
    formatters_by_ft = {
      java = { "google-java-format" },
      xml = { "xmllint" },
    },
  },
}
