local function config()
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'
    local opts = { silent = true, noremap = true }

    vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, opts)
    vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, opts)
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, opts)

    telescope.load_extension 'ui-select'
end

return {
    'nvim-telescope/telescope.nvim',

    requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim'
    },
    config = config
}
