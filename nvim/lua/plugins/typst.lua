return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            -- Export a PDF next to the source file every time it's saved.
            -- Valid values: "never" | "onSave" | "onType" | "onDocumentHasTitle"
            exportPdf = "onSave",
          },
        },
      },
    },
  },
}
