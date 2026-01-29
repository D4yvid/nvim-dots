local function config()
  vim.cmd.colorscheme 'sonokai'

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
  'sainnhe/sonokai',

  config = config
}
