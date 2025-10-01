local function config()
  local oil = require 'oil'

  local function parse_output(proc)
    local result = proc:wait()
    local ret = {}

    if result.code == 0 then
      for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
        line = line:gsub("/$", "")
        ret[line] = true
      end
    end
    return ret
  end

  local function new_git_status()
    return setmetatable({}, {
      __index = function(self, key)
        local ignore_proc = vim.system(
          { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
          {
            cwd = key,
            text = true,
          }
        )
        local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
          cwd = key,
          text = true,
        })
        local ret = {
          ignored = parse_output(ignore_proc),
          tracked = parse_output(tracked_proc),
        }

        rawset(self, key, ret)
        return ret
      end,
    })
  end
  local git_status = new_git_status()

  local refresh = require("oil.actions").refresh
  local orig_refresh = refresh.callback
  refresh.callback = function(...)
    git_status = new_git_status()
    orig_refresh(...)
  end

  oil.setup {
    delete_to_trash = true,

    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,

    float = {
      border = 'single',
      --
      -- override = function(cfg)
      --   local split_width = require 'centered':width()
      --   local win_width = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win())
      --
      --   cfg.width = win_width - 4
      --   cfg.col = split_width + 2
      --
      --   return cfg
      -- end
    },

    view_options = {
      is_hidden_file = function(name, bufnr)
        local dir = require("oil").get_current_dir(bufnr)
        local is_dotfile = vim.startswith(name, ".") and name ~= ".."

        -- if no local directory (e.g. for ssh connections), just hide dotfiles
        if not dir then
          return is_dotfile
        end

        -- dotfiles are considered hidden unless tracked
        if is_dotfile then
          return not git_status[dir].tracked[name]
        else
          -- Check if file is gitignored
          return git_status[dir].ignored[name]
        end
      end,
    },
  }

  vim.keymap.set('n', '<leader>e', function()
    -- TODO: change highlight for oil buffer

    oil.toggle_float()
  end, { noremap = true, silent = true })
end

return {
  'stevearc/oil.nvim',

  requires = "echasnovski/mini.icons",
  config = config
}
