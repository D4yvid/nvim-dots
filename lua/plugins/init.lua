-- Setup lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	}
end

vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require 'lazy'.setup {
	{
		'olivercederborg/poimandres.nvim',

		lazy = false,
		priority = 1000,

		config = function (opts)
			require'poimandres'.setup(opts)
		end,

		init = function ()
			vim.cmd.colorscheme 'poimandres'
		end,

		opts = {}
	},

	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { indent = { char = '▏' } } },

	{
		'nvim-treesitter/nvim-treesitter',

		dependencies = {'windwp/nvim-ts-autotag'},

		config = function ()
			require 'nvim-treesitter.configs'.setup {
				ensure_installed = { 'c', 'lua' },
				highlight = { enable = true, additional_vim_regex_highlighting = false },
				autotag = { enable = true }
			}
		end,

		lazy = false
	},

	{
		"neovim/nvim-lspconfig",

		dependencies = {
			'dcampos/nvim-snippy',
			'dcampos/cmp-snippy',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/nvim-cmp',
			'windwp/nvim-autopairs',
		},

		config = function () require 'lsp' end,
		lazy = false
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",

		dependencies = {
			"nvim-lua/plenary.nvim",

			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},

		config = function () require 'plugins.neotree' end
	},

	{
		'romgrk/barbar.nvim',

		dependencies = {
			'nvim-tree/nvim-web-devicons',
		},

		init = function() vim.g.barbar_auto_setup = false end,

		opts = {
			clickable = true,
			hide = { extensions = false, inactive = false },
			separator = { left = '', right = '' },
		},

		version = '^1.0.0',
	},

	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },

		config = function () require 'plugins.telescope' end
	}
}
