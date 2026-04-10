local function config()
  vim.g.sonokai_better_performance = 1
  vim.g.sonokai_enable_italic = 1
  vim.g.sonokai_transparent_background = 1

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
