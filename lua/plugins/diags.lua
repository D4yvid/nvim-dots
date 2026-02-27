local function config()
    local trouble = require 'trouble'
    local wsdiags = require 'workspace-diagnostics'

    trouble.setup()

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local buf = ev.buf

            wsdiags.populate_workspace_diagnostics(client, buf)
        end
    })

    vim.keymap.set('n', '<leader>dd', function()
        vim.cmd.Telescope('diagnostics')
    end, { silent = true, noremap = true })
end

return {
    'folke/trouble.nvim',

    requires = {
        'artemave/workspace-diagnostics.nvim'
    },

    config = config
}
