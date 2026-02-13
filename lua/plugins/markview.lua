return {
  'OXY2DEV/markview.nvim',
  lazy = false,

  requires = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local kiwi_path = vim.fn.expand('~/docs')

    require('markview').setup({
      preview = {
        filetypes = { 'markdown' },
        ignore_buftypes = { 'nofile' },

        condition = function(buffer)
          local bufname = vim.api.nvim_buf_get_name(buffer)
          return bufname:find(kiwi_path, 1, true) ~= nil
        end,
      },
    })
  end,
}
