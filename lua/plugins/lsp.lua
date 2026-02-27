local function config()
  local blink = require 'blink.cmp'

  ---@type table
  local capabilities = blink.get_lsp_capabilities()
  local servers = { 'clangd', 'lua_ls', 'gopls', 'ts_ls', 'qmlls', 'jsonls', 'mesonlsp' }

  local function get_lua_libraries()
    local libraries = {
      vim.env.VIMRUNTIME,
    }

    local path = vim.fn.stdpath('data') .. '/site/pack'

    for _, value in pairs(vim.opt.runtimepath:get()) do
      if value:sub(1, #path) == path then
        table.insert(libraries, value)
      end
    end

    return libraries
  end

  local overrides = {
    jsonls = {
      capabilities = {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true
            }
          }
        }
      }
    },

    sourcekit = {
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      }
    },

    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT'
          },

          workspace = {
            checkThirdParty = false,

            library = get_lua_libraries(),
          },

          diagnostics = {
            globals = {
            }
          }
        }
      }
    }
  }

  local function overrides_for(server)
    local opts = {
      capabilities = capabilities
    }

    local tbl = overrides[server]

    if type(tbl) ~= 'table' then
      return opts
    end

    if type(tbl.capabilities) == 'table' then
      opts.capabilities = vim.tbl_deep_extend('keep', opts.capabilities, tbl.capabilities)
    end

    return vim.tbl_deep_extend('keep', opts, tbl)
  end

  for _, server in ipairs(servers) do
    local opts = overrides_for(server)

    vim.lsp.enable(server)
    vim.lsp.config[server] = opts
  end

  blink.setup {
    appearance = {
      nerd_font_variant = 'normal'
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'avante' },
      providers = {
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          enabled = true,
          async = true,
          timeout_ms = 100,
          max_items = 100
        },
        avante = {
          module = 'blink-cmp-avante',
          name = 'Avante',
          opts = {
            -- options for blink-cmp-avante
          }
        }
      }
    },

    completion = {
      list = {
        max_items = 100,

        selection = {
          preselect = false,
          auto_insert = false
        }
      },

      ghost_text = {
        enabled = false -- Disabled in favor of cursor-tab AI completions
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500
      },

      trigger = {
        show_on_accept_on_trigger_character = true,
        show_on_insert_on_trigger_character = true,
        show_on_trigger_character = true,

        show_on_blocked_trigger_characters = { ' ', '\n', '\t' },

        show_on_x_blocked_trigger_characters = { "'", '"', '(', '{', '[' }
      },

      menu = {
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,

              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },

            kind = {
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            }
          },

          columns = {
            { 'kind_icon',        'label', gap = 2 },
            { 'label_description' }
          }
        }
      }
    },

    keymap = {
      preset = 'default'
    },

    signature = {
      enabled = true,

      window = {
        show_documentation = true
      }
    }
  }

  vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅙 ',
        [vim.diagnostic.severity.HINT] = '󰋼 ',
        [vim.diagnostic.severity.INFO] = '󰋼 ',
        [vim.diagnostic.severity.WARN] = '󰀦 '
      }
    }
  })

  vim.api.nvim_create_autocmd({ 'LspAttach' }, {
    callback = function(ev)
      local function nmap(k, f)
        vim.keymap.set('n', k, f, { silent = true, noremap = true })
      end

      local cid = ev.data.client_id
      local lsc = vim.lsp.get_client_by_id(cid)
      local bufnr = ev.buf

      assert(lsc)

      if lsc.config.name == 'sourcekit' then
        local ns = vim.api.nvim_create_augroup('sourcekit-reload', { clear = true })

        vim.api.nvim_create_autocmd({ 'BufWrite' }, {
          pattern = { 'Package.swift', '**/Package.swift' },
          group = ns,

          callback = function()
            local start = vim.fn.reltime()

            vim.fn.jobstart({ 'swift', 'package', 'resolve' }, {
              on_exit = function()
                local _end = vim.fn.reltime()
                local diff = vim.fn.reltimefloat(vim.fn.reltime(start, _end)) / 1000

                if diff > 1000 then
                  vim.notify('Resolved project in ' .. (diff / 1000) .. 's')
                else
                  vim.notify('Resolved project in ' .. diff .. 'ms')
                end
              end
            })
          end
        })
      end

      nmap('gd', vim.lsp.buf.definition)
      nmap('gD', vim.lsp.buf.declaration)

      nmap('<leader>r', vim.lsp.buf.rename)
      nmap('<leader>c', vim.lsp.buf.code_action)

      nmap('<leader>d', vim.diagnostic.open_float)
      nmap('<leader>lf', vim.lsp.buf.format)

      nmap('d]', function()
        vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_next() })
      end)

      nmap('d[', function()
        vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_prev() })
      end)

      if vim.bo.filetype == 'c' then
        nmap('<leader>s', function() vim.cmd.LspClangdSwitchSourceHeader() end)
      end

      vim.api.nvim_create_augroup('AutoFormatting', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        group = 'AutoFormatting',

        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end
  })
end

return {
  'neovim/nvim-lspconfig',

  requires = {
    {
      'saghen/blink.cmp',

      tag = 'v1.*'
    },
    'Kaiser-Yang/blink-cmp-avante',
    'rafamadriz/friendly-snippets',
    'nvim-flutter/flutter-tools.nvim'
  },
  config = config
}
