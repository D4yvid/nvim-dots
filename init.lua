local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

---@diagnostic disable-next-line: undefined-field
  if not vim.uv.fs_stat(pckr_path) then
    vim.fn.system {
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    }
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require 'options'
require 'plugins'

if vim.g.neovide then
  require 'neovide'
end

-- require 'centered':init {
--   size = 0.16
-- }
