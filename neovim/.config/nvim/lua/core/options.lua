-- Common neovim options
vim.opt.backup = false                -- creates a backup file
vim.opt.clipboard = "unnamedplus"     -- gives access to system clipboard
vim.opt.conceallevel = 0              -- makes `` visible in markdown
vim.opt.expandtab = true		          -- Tab is expanded as spaces
vim.opt.hlsearch = true               -- highlights search results
vim.opt.ignorecase = true		          -- ignore case sensitivity ...
vim.opt.iskeyword:append("-")         -- treats words with - as single words
vim.opt.mouse = "a"                   -- enables mouse in neovim
vim.opt.number = true			            -- display line number
vim.opt.relativenumber = true		      -- enable relative numbers
vim.opt.shiftwidth = 2			          -- amount of characters for indentation
vim.opt.smartcase = true		          -- unless we typed an upper case 
vim.opt.swapfile = false              -- disables swap file
vim.opt.tabstop = 2			              -- number of spaces for Tab character
vim.opt.termguicolors = true          -- set term gui colors
vim.opt.undofile = true               -- enables persistent undo
