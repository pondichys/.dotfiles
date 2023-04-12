return {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" },             -- Required
    { 
      "williamboman/mason.nvim",
      build = function()
        pcall(vim.cmd, "MasonUpdate")
      end
    },           -- Optional
    { "williamboman/mason-lspconfig.nvim" }, -- Optional

    -- Null-ls
    { "jose-elias-alvarez/null-ls.nvim" },
    { "jay-babu/mason-null-ls.nvim" }, -- Optional

    -- Autocompletion
    { "hrsh7th/nvim-cmp" },         -- Required
    { "hrsh7th/cmp-nvim-lsp" },     -- Required
    { "hrsh7th/cmp-buffer" },       -- Optional
    { "hrsh7th/cmp-path" },         -- Optional
    { "saadparwaiz1/cmp_luasnip" }, -- Optional
    { "hrsh7th/cmp-nvim-lua" },     -- Optional

    -- Snippets
    { "L3MON4D3/LuaSnip" },             -- Required
    { "rafamadriz/friendly-snippets" }, -- Optional
  },
  config = function()
    local lsp = require("lsp-zero").preset({})

    lsp.on_attach(function(client,bufnr)
      lsp.default_keymaps({buffer = bufnr})
    end)

    -- Automatic installed language servers
    lsp.ensure_installed({
      "ansiblels",
      "bashls",
      "dockerls",
      "gopls",
      "jsonls",
      "lua_ls",
      "ruff_lsp",
      "rust_analyzer",
      "terraformls",
      "yamlls",
    })

    -- Use icons in sign column
    lsp.set_sign_icons({
      error = '✘',
      warn = '▲',
      hint = '⚑',
      info = '»'
    })

    -- Configure language server for Lua
    require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

    lsp.setup()

    local null_ls = require('null-ls')

    null_ls.setup({
      sources = {
        -- Replace these with the tools you want to install
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.stylua,
      }
    })

    -- See mason-null-ls.nvim's documentation for more details:
    -- https://github.com/jay-babu/mason-null-ls.nvim#setup
    require('mason-null-ls').setup({
      ensure_installed = nil,
      automatic_installation = true,
    })
    
  end,

}
