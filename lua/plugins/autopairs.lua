local function config()
    local autopairs = require 'ultimate-autopair'

    autopairs.setup {
    }
end

return {
    'altermo/ultimate-autopair.nvim',

    config = config
}
