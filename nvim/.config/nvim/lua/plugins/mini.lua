-- Some mini plugins
return {
	-- animate to have some nice animations
	{
		"echasnovski/mini.animate",
		version = "*",
		config = function(_, _)
			require("mini.animate").setup()
		end,
	},
	-- better buffer remove
	{
		"echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
    },
	},
	-- comments
	{
		"echasnovski/mini.comment",
		version = "*",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
		event = "VeryLazy",
		opts = {
			hooks = {
				pre = function()
					require("ts_context_commentstring.internal").update_commentstring({})
				end,
			},
		},
		config = function(_, opts)
			require("mini.comment").setup(opts)
		end,
	},
	-- auto complete pairs
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup({})
		end,
	},
	-- easy manipulate surround character
	{
		"echasnovski/mini.surround",
		version = "*",
		opts = {
			mappings = {
				add = "gza", -- Add surrounding in Normal and Visual modes
				delete = "gzd", -- Delete surrounding
				find = "gzf", -- Find surrounding (to the right)
				find_left = "gzF", -- Find surrounding (to the left)
				highlight = "gzh", -- Highlight surrounding
				replace = "gzr", -- Replace surrounding
				update_n_lines = "gzn", -- Update `n_lines`
			},
		},
		config = function(_, opts)
			-- use gz mappings instead of s to prevent conflict with leap
			require("mini.surround").setup(opts)
		end,
	},
}
