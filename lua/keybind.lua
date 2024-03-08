local opts = { silent = true, noremap = true }
local map = function (m, k, f) vim.keymap.set(m, k, f, opts) end

local imap = function (k, f) map('i', k, f) end
local nmap = function (k, f) map('n', k, f) end
local vmap = function (k, f) map('v', k, f) end
local tmap = function (k, f) map('t', k, f) end
local smap = function (k, f) map('s', k, f) end

local leader = ' '

vim.g.mapleader = leader

nmap('<leader>qr', function ()
	-- Remove cache for statusline package
	package.preload['statusline'] = nil

	-- Reload configuration
	vim.cmd.source(vim.fn.stdpath('config') .. '/init.lua')
end)

nmap('<leader>e', function () vim.cmd.Neotree 'position=current' end)
nmap('<leader>t', function () vim.cmd.Neotree 'toggle' end)
nmap('<leader>f', function () vim.cmd.Telescope 'find_files' end)
nmap('<leader>g', function () vim.cmd.Telescope 'live_grep' end)
nmap('<leader>w', vim.cmd.write)

nmap('<leader>p', '<Cmd>BufferPrevious<CR>')
nmap('<leader>n', '<Cmd>BufferNext<CR>')
nmap('<leader>h', '<Cmd>BufferGoto 1<CR>')
nmap('<leader>j', '<Cmd>BufferGoto 2<CR>')
nmap('<leader>k', '<Cmd>BufferGoto 3<CR>')
nmap('<leader>l', '<Cmd>BufferGoto 4<CR>')
nmap('<leader>q', '<Cmd>BufferClose<CR>')

