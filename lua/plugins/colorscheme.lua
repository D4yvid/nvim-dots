local function config()
  local wal = require 'pywal'

  wal.setup {}

  vim.opt.termguicolors = true
  vim.opt.background = 'dark'

  vim.cmd [[
    hi clear  CursorLineNr
    hi clear  CursorLine
    hi link		CursorLineNr   CursorLine
    hi link		CursorLineSign CursorLine
  ]]
end

return {
  'AlphaTechnolog/pywal.nvim',

  config = config
}
