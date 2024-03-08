local neotree = require 'neo-tree'

neotree.setup {
	enable_diagnostics = false,

	default_component_configs = {
		git_status = {
			symbols = {
				added     = "",
				modified  = "",
				deleted   = "x",
				renamed   = "?",
				untracked = "?",
				ignored   = "",
				unstaged  = "U",
				staged    = "S",
				conflict  = "C",
			}
		},
	},

	window = {
		position = 'right',
		width = 30
	}
}
