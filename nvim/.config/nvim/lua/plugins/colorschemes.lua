return {
  { "catppuccin/nvim", 
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      local catppuccin = require "catppuccin"
      catppuccin.setup {
        flavour = "mocha",
      }
      catppuccin.load()
    end,
  },
  { "folke/tokyonight.nvim" }
}
