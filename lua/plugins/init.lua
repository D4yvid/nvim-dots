local pckr = require 'pckr'

require 'plugins.colorscheme'

pckr.add {
  require 'plugins.treesitter',
  require 'plugins.fileexplorer',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.autopairs',
  require 'plugins.indentline',
  require 'plugins.align',
  require 'plugins.diags'
}
