local function config()
  require 'claudecode'.setup {}

  vim.keymap.set('n', '<leader>ll', function()
    vim.cmd.ClaudeCode()
  end)

  vim.keymap.set('n', '<leader>la', function()
    local buf = vim.fn.bufnr()
    local name = vim.fn.bufname(buf)

    vim.cmd.ClaudeCodeAdd(name)
  end)

  vim.keymap.set('v', '<leader>la', function()
    local buf = vim.fn.bufnr()
    local name = vim.fn.bufname(buf)

    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    local start_line = start_pos[2]
    local start_col = start_pos[3]
    local end_line = end_pos[2]
    local end_col = end_pos[3]

    vim.cmd.ClaudeCodeAdd(name, start_line, end_line)
  end)
end

return {
  'coder/claudecode.nvim',

  config = config,
  requires = {
    'folke/snacks.nvim'
  }
}
