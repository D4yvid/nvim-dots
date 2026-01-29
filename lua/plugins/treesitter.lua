local function config()
  local ts = require 'nvim-treesitter.configs'

  ts.setup {
    ensure_installed = { 'c', 'lua', 'javascript', 'typescript', 'markdown', 'markdown_inline', 'vim', 'vimdoc' },

    highlight = {
      enable = true,
      disable = { "swift" }
    },

    indent = {
      enable = true
    }
  }
end

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',

  branch = 'master',
  config = config
}
