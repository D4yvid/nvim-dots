local function config()
  require 'indentmini'.setup {
    char = '▏'
  }

  vim.cmd.hi('link', 'IndentLine', 'LineNr')
  vim.cmd.hi('link', 'IndentLineCurrent', 'LineNr')
end

return {
  'nvimdev/indentmini.nvim',

  config = config
}
