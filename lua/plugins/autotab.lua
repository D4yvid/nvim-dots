local function config()
    local autotab = require 'autotab-nvim'

    autotab:setup()
end

return {
    "~/projects/nvim/plugins/autotab.nvim",

    config = config
}
