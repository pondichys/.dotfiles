return
{
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  opts = {
    ensure_installed = {
      "ansible-language-server",
      "bash-language-server",
      "dockerfile-language-server",
      "json-lsp",
      "lua-language-server",
      "ruff-lsp",          -- python
      "terraform-ls",       -- terraform
      "yaml-language-server",            -- yaml
    },
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    for _, tool in ipairs(opts.ensure_installed) do
      local p = mr.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end,
}
