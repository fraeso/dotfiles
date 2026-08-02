return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            -- "never" | "onSave" | "onType" | "onDocumentHasTitle"
            exportPdf = "onSave",
          },
        },
      },
    },
  },
}
