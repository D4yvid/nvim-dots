local function config()
    require 'restoration'.setup {
        auto_save = true,
        notify = true,

        preserve = {
            qflist = true,
            undo = true,
            folds = true
        },

        branch_scope = true,

        restore_venv = {
            enabled = true,
            patterns = { "venv", ".venv" },
        },

        picker = {
            default = "snacks",

            snacks = {
                layout = "default",

                icons = {
                    project = " ",
                    session = "󰑏 ",
                    branch = " ",
                },

                hl = {
                    base_dir = "SnacksPickerDir",
                    project_dir = "Directory",
                    session = "SnacksPickerBold",
                    branch = "SnacksPickerGitBranch",
                },
            },
        },

    }

    require 'snacks'.setup {
        bigfile = { enabled = true },
        dashboard = {
            enabled = true,

            preset = {
                header = [[       dMMMMb  dMMMMMP .aMMMb  dMP dMP dMP dMMMMMMMMb
      dMP dMP dMP     dMP"dMP dMP dMP amr dMP"dMP"dMP
     dMP dMP dMMMP   dMP dMP dMP dMP dMP dMP dMP dMP
 dMP dMP dMP     dMP.aMP  YMvAP" dMP dMP dMP dMP
dMP dMP dMMMMMP  VMMMP"    VP"  dMP dMP dMP dMP]],

                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = " ", key = "s", desc = "Restore Session", action = ":lua Snacks.dashboard.pick('projects')" },
                    { icon = " ", key = "t", desc = "Terminal", action = ":term" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },

            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },

                { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 1, padding = 1 },
                { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 1, padding = 1 },

                {
                    pane = 2,
                    icon = " ",
                    title = "Git Status",
                    section = "terminal",

                    enabled = function()
                        return Snacks.git.get_root() ~= nil
                    end,

                    cmd = "git status --short --branch --renames",
                    height = 5,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 1,
                },
            },
        },

        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    }
end

return {
    'paradoxical-dev/restoration.nvim',

    requires = {
        'niuiic/quickfix.nvim',
        'folke/snacks.nvim',
        'folke/trouble.nvim'
    },

    config = config
}
