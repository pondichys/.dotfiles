-- Configuration of treesitter plugin
-- Treesitter enables smart syntax highlighting to NeoVim 
-- for a lot of programming languages
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
        -- add new parsers here if needed
          "bash",
          "gitcommit",
          "go",
          "gomod",
          "hcl",                    -- equivalent to terraform -> refers to same Github repository https://github.com/MichaHoffmann/tree-sitter-hcl
          "html",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "rego",
          "rust",
          "sxhkdrc",
          "toml",
          "vim",
          "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  }
}
