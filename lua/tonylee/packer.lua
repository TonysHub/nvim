--kk This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  
  use {
			'nvim-treesitter/nvim-treesitter',
			run = function()
				local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
				ts_update()
			end,}
  use('nvim-treesitter/playground')
  use('theprimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v2.x',
	requires = {
	   -- LSP Support
	    {'neovim/nvim-lspconfig'},             -- Required
	    {                                      -- Optional
	      'williamboman/mason.nvim',
	      run = function()
		pcall(vim.cmd, 'MasonUpdate')
	      end,
	    },
	    {'williamboman/mason-lspconfig.nvim'}, -- Optional

	    -- Autocompletion
	    {'hrsh7th/nvim-cmp'},     -- Required
	    {'hrsh7th/cmp-nvim-lsp'}, -- Required
	    {'L3MON4D3/LuaSnip'},     -- Required
	  }
    }
    -- use('preservim/nerdtree')
    use('kyazdani42/nvim-web-devicons')
    use('kyazdani42/nvim-tree.lua')
    use {"akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
        end}
    use("github/copilot.vim")
    use("preservim/tagbar")
    use("tpope/vim-surround")
    use("tpope/vim-commentary")
    use("vim-airline/vim-airline")
    use('Mofiqul/vscode.nvim')
    use('ryanoasis/vim-devicons')
    use('mg979/vim-visual-multi', {branch= 'master'})
    
end)

