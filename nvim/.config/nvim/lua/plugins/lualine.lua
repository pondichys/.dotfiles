return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    
    local icons = require "config.icons"

    local hide_in_width = function()
	    return vim.fn.winwidth(0) > 80
    end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warnings", "info", "hint" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
	    colored = true,
	    always_visible = false,
	    update_in_insert = true,
    }

    local diff = {
    	"diff",
	    colored = true,
	    symbols = { added = "+ ", modified = " ", removed = " " }, -- changes diff symbols
	    cond = hide_in_width,
    }

    local   lsp_client = {
      function(msg)
        msg = msg or ""
        local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }

        if next(buf_clients) == nil then
          if type(msg) == "boolean" or #msg == 0 then
            return ""
          end
          return msg
        end

        local buf_ft = vim.bo.filetype
        local buf_client_names = {}

        -- add client
        for _, client in pairs(buf_clients) do
          if client.name ~= "null-ls" then
            table.insert(buf_client_names, client.name)
          end
        end

        -- add formatter
        local lsp_utils = require "plugins.lsp.utils"
        local formatters = lsp_utils.list_formatters(buf_ft)
        vim.list_extend(buf_client_names, formatters)

        -- add linter
        local linters = lsp_utils.list_linters(buf_ft)
        vim.list_extend(buf_client_names, linters)

        -- add hover
        local hovers = lsp_utils.list_hovers(buf_ft)
        vim.list_extend(buf_client_names, hovers)

        -- add code action
        local code_actions = lsp_utils.list_code_actions(buf_ft)
        vim.list_extend(buf_client_names, code_actions)

        local hash = {}
        local client_names = {}
        for _, v in ipairs(buf_client_names) do
          if not hash[v] then
            client_names[#client_names + 1] = v
            hash[v] = true
          end
        end
        table.sort(client_names)
        return icons.ui.Code .. " " .. table.concat(client_names, ", ") .. " " .. icons.ui.Code
      end,
      -- icon = icons.ui.Code,
      colored = true,
      on_click = function()
        vim.cmd [[LspInfo]]
      end,
    }

    local spaces = function()
	    return  icons.ui.Tab .. " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
    end

    require("lualine").setup {
      options = {
        icons_enabled = true,
        component_separators = "|",
        theme = "auto",
        disabled_filetypes = {
          statusline = { "alpha", "dashboard", "lazy" },
          winbar = {
            "help",
            "alpha",
            "lazy",
          },
        },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "diff", diagnostics },
        lualine_x = { "filename", spaces, "encoding", "fileformat", "filetype", "progress" },
        lualine_y = {};
        lualine_z = { "location" },
      },
      extensions = {
        "lazy",
        "neo-tree",
        "quickfix",
        "toggleterm",
        "trouble",
      },
    }
  end,
}
