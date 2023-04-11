return {
  -- insert common plugins here that do not require much configuration
  -- persistence is a session management plugin
  { 
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  -- library used by a lot of neovim plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  -- better notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    enabled = true,
    config = true,
  },
  -- better neovim ui
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = true,
  },
  -- UI elements for plugins
  "MunifTanjim/nui.nvim",
  -- icons for plugins
  {
    "nvim-tree/nvim-web-devicons",
    config = true,
  },
  -- indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
    },
  },
}