lua require('globals')
lua require('options').setup()

" # Plugins
" ------------------------------------------------------------
lua << EOF
require('packer').startup(function()
	use { 'wbthomason/packer.nvim' }

	-- Dependencies
	use { 'nvim-lua/plenary.nvim' }

	-- Gui enhancements
	use { 'hoob3rt/lualine.nvim' }

	-- Multicursor
	use { 'terryma/vim-multiple-cursors' }

	-- Fuzzy finding
	use { 'airblade/vim-rooter' }
	use { 'nvim-telescope/telescope.nvim' }

	-- Filetree
    use { 'kyazdani42/nvim-tree.lua' }

	-- Lists
	use { '~/Projects/trouble.nvim' }
	use { 'folke/todo-comments.nvim' }

	-- Git
	use { 'tpope/vim-fugitive' }
	use { 'lewis6991/gitsigns.nvim' }

	-- Lsp
	use { 'neovim/nvim-lspconfig' }
	use { 'nvim-lua/lsp_extensions.nvim' }
	use { 'nvim-lua/lsp-status.nvim' }

	-- Debugging
	use { 'mfussenegger/nvim-dap' }
	use { 'rcarriga/nvim-dap-ui' }

	-- Completion
	use { 'hrsh7th/nvim-cmp' }
	use { 'hrsh7th/cmp-path' }
	use { 'hrsh7th/cmp-buffer' }
	use { 'hrsh7th/cmp-nvim-lua' }
	use { 'hrsh7th/cmp-nvim-lsp' }
	use { 'hrsh7th/vim-vsnip' }

	-- Treesitter
	use { 'nvim-treesitter/nvim-treesitter', run = function() vim.cmd(':TSUpdate') end }
	use { 'nvim-treesitter/playground' }

	-- Language tools
	use { 'plasticboy/vim-markdown' }
	use { 'iamcco/markdown-preview.nvim', run = function() vim.call('mkdp#util#install()') end }
	use { 'teal-language/vim-teal' }
	use { 'rust-lang/rust.vim' }
	use { 'dhruvasagar/vim-table-mode' }
	use { '~/Projects/crates.nvim' }

	-- Fancy notifications
	use { 'rcarriga/nvim-notify' }

	-- Miscellaneous
	use { 'farmergreg/vim-lastplace' }
	use { '907th/vim-auto-save' }

	-- Discord rich presence
	use { 'andweeb/presence.nvim' }

	-- Browser Integration
	use { 'glacambre/firenvim', run = function() vim.call('firenvim#install(0)') end }
end)
EOF

" # Config
" ------------------------------------------------------------
lua require('util.maps').setup()
lua require('mappings').setup()
lua require('colors').setup()
lua require('highlight').setup()    

" # Plugin config
" ------------------------------------------------------------
lua vim.notify = require('notify')
lua require('config.lang').setup()
lua require('config.crates').setup()
lua require('config.gitsigns').setup()
lua require('config.cmp').setup()
lua require('config.lsp').setup()
lua require('config.trouble').setup()
lua require('config.todo-comments').setup()
lua require('config.dap').setup()
lua require('config.treesitter').setup()
lua require('config.telescope').setup()
lua require('config.nvim-tree').setup()
lua require('config.multi-cursor').setup()
lua require('config.firenvim').setup()
