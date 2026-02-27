local function config()
    local kiwi = require 'kiwi'

    kiwi.setup {
        {
            name = 'docs',
            path = vim.fn.expand('~/docs')
        }
    }

    vim.keymap.set('n', '<leader>ww', kiwi.open_wiki_index, { noremap = true, silent = true })
    vim.keymap.set('n', 'T', kiwi.todo.toggle, { noremap = true, silent = true })

    vim.opt.concealcursor = 'n'
    vim.opt.conceallevel = 3
end

return {
    'serenevoid/kiwi.nvim',

    config = config
}
