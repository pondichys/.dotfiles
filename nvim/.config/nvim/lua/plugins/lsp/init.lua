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

    -- Configure language servers
    -- Lua
    require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
    -- YAML
    require("lspconfig").yamlls.setup({
      settings = {
        yaml = {
          keyOrdering = false
        }
      }
    })


    lsp.setup()

    -- Configure autocompletion with cmp
    local snip_status_ok, luasnip = pcall(require, "luasnip")
    if not snip_status_ok then
      return
    end

    local check_backspace = function()
      local col = vim.fn.col(".") - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
    end

    local cmp = require("cmp")

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif check_backspace() then
            fallback()
          else
            fallback()
          end
        end, {
            "i",
            "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
            "i",
            "s",
        }),
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sources = {
        {name = "path"},
        {name = "nvim_lsp"},
        {name = "buffer", keyword_length = 3},
        {name = "luasnip", keyword_length = 2},
        {name = "codeium"},
      }
    })

    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Replace these with the tools you want to install
        null_ls.builtins.formatting.beautysh,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.terraform_fmt,
      }
    })

    -- See mason-null-ls.nvim's documentation for more details:
    -- https://github.com/jay-babu/mason-null-ls.nvim#setup
    require("mason-null-ls").setup({
      ensure_installed = nil,
      automatic_installation = true,
    })
    
  end,

}
