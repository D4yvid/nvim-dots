vim.g.mapleader = ' '

vim.opt.background = 'dark'

vim.opt.termguicolors = true
vim.opt.backspace = 'eol,start,indent'
vim.opt.number = true

vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse:append 'a'
vim.opt.shortmess:append 'c'
vim.opt.updatetime = 300
vim.opt.timeoutlen = 700
vim.opt.cmdheight = 0

vim.opt.modeline = true

vim.opt.swapfile = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"

vim.opt.cmdheight = 1

vim.opt.laststatus = 0
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 16

vim.opt.signcolumn = 'yes'
vim.opt.fillchars = { eob = ' ', vert = '▏' }

vim.opt.showmode = false
vim.opt.conceallevel = 3

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:3'

vim.opt.completeopt:append('menuone', 'popuphidden', 'noinsert', 'noselect')

local keyset = vim.keymap.set

keyset('v', 'K', ":m '<-2<CR>gv=gv", { silent = true, noremap = true })
keyset('v', 'J', ":m '>+1<CR>gv=gv", { silent = true, noremap = true })

keyset('n', '<C-n>', '<cmd>tabnext<CR>', { silent = true, noremap = true })
keyset('n', '<C-p>', '<cmd>tabprevious<CR>', { silent = true, noremap = true })
keyset('n', '<C-q>', '<cmd>tabclose<CR>', { silent = true, noremap = true })
keyset('n', '<leader>tc', '<cmd>tabnew<CR>', { silent = true, noremap = true })

keyset({ 'n', 'v', 's', }, '<leader>p', '"+p', { silent = true, noremap = true })
keyset({ 'n', 'v', 's', }, '<leader>y', '"+y', { silent = true, noremap = true })

keyset('n', '<leader>h', '<cmd>nohl<CR>', { silent = true, noremap = true })
keyset('n', '<leader>w', '<cmd>write!<CR>', { silent = true, noremap = true })
keyset('n', 'M', '<cmd>:Man<CR>', { silent = true, noremap = true })

keyset('t', '<C-w>h', function()
    return vim.api.nvim_replace_termcodes('<C-\\><C-n><C-w>h', true, true, true)
end, { expr = true, silent = true, noremap = true })

keyset('t', '<C-w>j', function()
    return vim.api.nvim_replace_termcodes('<C-\\><C-n><C-w>j', true, true, true)
end, { expr = true, silent = true, noremap = true })

keyset('t', '<C-w>k', function()
    return vim.api.nvim_replace_termcodes('<C-\\><C-n><C-w>k', true, true, true)
end, { expr = true, silent = true, noremap = true })

keyset('t', '<C-w>l', function()
    return vim.api.nvim_replace_termcodes('<C-\\><C-n><C-w>l', true, true, true)
end, { expr = true, silent = true, noremap = true })

vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    pattern = "term://*",
    callback = function()
        vim.cmd("startinsert")
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-config", { clear = true }),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
})

local ao = vim.api.nvim_create_augroup('Assembly', {
    clear = true
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufFilePre', 'BufRead', 'BufNew' }, {
    pattern = { "*.S", "*.asm" },
    group = ao,

    callback = function()
        vim.bo.tabstop = 8
        vim.bo.softtabstop = 8
        vim.bo.shiftwidth = 8
        vim.bo.expandtab = false
    end
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufFilePre', 'BufRead', 'BufNew' }, {
    pattern = { "*.h" },
    group = ao,

    callback = function()
        vim.bo.filetype = 'c'
    end
})
