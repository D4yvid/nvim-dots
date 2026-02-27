local a = require 'plenary.async'

local runtime_config = require 'neovide-runtime'
local runtime_config_path = vim.fn.stdpath('config') .. '/lua/neovide-runtime.lua'

local function maybe_load_runtime_config()
  if type(runtime_config) ~= 'table' then return end

  for key, value in pairs(runtime_config) do
    vim.g['neovide_' .. key] = value
  end
end

local function write_runtime_config(key, value)
  if type(runtime_config) ~= 'table' then
    runtime_config = {}
  end

  runtime_config[key] = value

  local lines = {
    "return {"
  }

  for key, value in pairs(runtime_config) do
    table.insert(lines, "  " .. tostring(key) .. " = " .. tostring(value))
  end

  table.insert(lines, "}")

  vim.fn.writefile(lines, runtime_config_path, "s")

  -- Remove caches
  package.preload['neovide-runtime'] = nil
  package.loaded['neovide-runtime'] = nil

  -- Load the config module again
  runtime_config = require 'neovide-runtime'

  maybe_load_runtime_config()
end

vim.g.neovide_opacity = 0.8

vim.g.neovide_refresh_rate = 100

vim.o.guifont = 'GeistMono Nerd Font:h13:#e-subpixelantialias:#h-full'
vim.o.linespace = 8
vim.g.neovide_text_gamma = 0
vim.g.neovide_text_contrast = 0.0
vim.g.neovide_window_blurred = true

vim.g.neovide_confirm_quit = true
vim.g.neovide_floating_corner_radius = 0.4

vim.g.neovide_floating_blur_amount_x = 4
vim.g.neovide_floating_blur_amount_y = 4

vim.g.neovide_scale_factor = 1.0

vim.keymap.set({ "n", "v" }, "<C-=>", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1

  write_runtime_config('scale_factor', vim.g.neovide_scale_factor)
end)

vim.keymap.set({ "n", "v" }, "<C-->", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1

  write_runtime_config('scale_factor', vim.g.neovide_scale_factor)
end)

vim.keymap.set({ "n", "v" }, "<C-0>", function()
  vim.g.neovide_scale_factor = 1.0

  write_runtime_config('scale_factor', vim.g.neovide_scale_factor)
end)

local function paste_from_clipboard()
  -- Get system clipboard content
  local cb_content = vim.fn.getreg('+')
  -- We use nvim_feedkeys with 'n' (noremap) and 't' (terminal-like) 
  -- to safely escape the content so it's treated as literal text.
  return vim.api.nvim_replace_termcodes(cb_content, true, true, true)
end

-- 1. Normal Mode
vim.keymap.set('n', '<C-S-V>', '"+P', { desc = 'Paste from clipboard' })

-- 2. Insert Mode
-- <C-R><C-O>+ is the most reliable way to paste in Insert mode 
-- because it preserves indentation and literal characters.
vim.keymap.set('i', '<C-S-V>', '<C-R><C-O>+', { desc = 'Paste from clipboard' })

-- 3. Command Mode
vim.keymap.set('c', '<C-S-V>', '<C-R>+', { desc = 'Paste from clipboard' })

-- 4. Visual Mode (Replace selection)
vim.keymap.set('v', '<C-S-V>', '"+P', { desc = 'Paste from clipboard' })

-- 5. Terminal Mode
vim.keymap.set('t', '<C-S-V>', function()
  -- In terminal mode, we "type" the keys into the buffer
  local cb_content = vim.fn.getreg('+')
  -- Using nvim_chan_send or feedkeys is usually safer for terminals
  -- but since you wanted the 'expr' logic, here is the implementation:
  return vim.api.nvim_replace_termcodes(cb_content, true, true, true)
end, { expr = true, desc = 'Terminal Paste' })

-- Copy selection to system clipboard (requires being in Terminal-Normal mode)
-- Note: In terminal mode, you usually have to enter Normal mode to select text.
vim.keymap.set('v', '<C-S-C>', '"+y', { desc = 'Copy to System Clipboard' })

maybe_load_runtime_config()
