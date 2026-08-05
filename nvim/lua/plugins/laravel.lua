return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    keys = {
      { "<leader>la", function() Laravel.pickers.artisan() end, desc = "Artisan" },
      { "<leader>lr", function() Laravel.pickers.routes() end, desc = "Routes" },
      { "<leader>lm", function() Laravel.pickers.make() end, desc = "Make" },
      {
        "gf",
        function()
          if Laravel.app("gf").cursorOnResource() then
            return "<cmd>lua Laravel.commands.run('gf')<cr>"
          end
          return "gf"
        end,
        ft = { "php", "blade" },
        expr = true,
        noremap = true,
        desc = "Go to resource",
      },
    },
    opts = {
      features = {
        pickers = {
          provider = "snacks",
        },
      },
    },
  },
}
