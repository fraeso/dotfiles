return {
  -- {
  --   "chomosuke/typst-preview.nvim",
  --   opts = {
  --     -- Open the preview in Chrome instead of the system default browser.
  --     open_cmd = 'open -a "Google Chrome" %s',
  --   },
  -- },
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
