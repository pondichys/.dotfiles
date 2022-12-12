require'nvim-treesitter.configs'.setup {
  -- List of parsers
  ensure_installed = { "bash", "c", "go", "hcl", "json", "lua", "markdown", "python", "rust", "vim", "yaml" },

  -- Install parsers
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
