local function config()
  vim.opt.termguicolors = true
  vim.opt.background = 'dark'

  require("xcodedark").setup({
    transparent = true,

    integrations = {
      telescope = true,
      nvim_tree = true,
      gitsigns = true,
      bufferline = true,
      incline = true,
      lazygit = true,
      which_key = true,
      notify = true,
    },

    styles = {
      comments = { italic = true },
      keywords = { bold = true },
      functions = {},
      variables = {},
      strings = {},
      booleans = { bold = true },
      types = {},
      constants = {},
      operators = {},
      punctuation = {},
    },

    terminal_colors = true,
  })

  vim.cmd.colorscheme 'xcodedark'

  --- Make the number view have the same color as the cursor line
  vim.cmd [[
    hi clear CursorLineNr
    hi link		CursorLineNr   CursorLine
    hi link		CursorLineSign CursorLine
  ]]
end

return {
  'V4N1LLA-1CE/xcodedark.nvim',

  config = config
}
