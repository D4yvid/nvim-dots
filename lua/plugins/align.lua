local function config()
  local NS = { silent = true, noremap = true }

  vim.keymap.set(
    'x',
    'ac',

    function()
      require 'align'.align_to_char {
        length = 1,
      }
    end,
    NS
  )

  vim.keymap.set(
    'x',
    'aw',

    function()
      require 'align'.align_to_string {
        preview = true,
        regex = true,
      }
    end,
    NS
  )
end

return {
  'Vonr/align.nvim',

  config = config
}
