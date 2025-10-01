local function config()
  local lspconfig = require 'lspconfig'
  local blink = require 'blink.cmp'

  require 'flutter-tools'.setup {}

  local capabilities = blink.get_lsp_capabilities()

  lspconfig.mesonlsp.setup {
    capabilities = capabilities
  }

  lspconfig.gopls.setup {
    capabilities = capabilities
  }

  lspconfig.ts_ls.setup {
    capabilities = capabilities
  }

  lspconfig.svelte.setup {
    capabilities = capabilities
  }

  lspconfig.pyright.setup {
    capabilities = capabilities
  }

  -- lspconfig.clangd.setup {
  --   capabilities = capabilities
  -- }

  lspconfig.sourcekit.setup {
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    }
  }

  lspconfig.neocmake.setup {}

  lspconfig.lua_ls.setup {
    capabilites = capabilities,

    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT'
        },

        workspace = {
          checkThirdParty = false,

          library = {
            vim.env.VIMRUNTIME
          },
        },

        diagnostics = {
          globals = {
          }
        }
      }
    }
  }

  lspconfig.tailwindcss.setup {
    capabilities = capabilities
  }

  lspconfig.rust_analyzer.setup {
    capabilities = capabilities
  }

  blink.setup {
    appearance = {
      nerd_font_variant = 'normal'
    },

    sources = {
      providers = {
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          enabled = true,
          async = true,
          timeout_ms = 100,
          max_items = 100
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
        enabled = true
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
        vim.diagnostic.goto_next()
      end)

      nmap('d[', function()
        vim.diagnostic.goto_prev()
      end)

      if vim.bo.filetype == 'c' then
        nmap('<leader>s', function() vim.cmd.ClangdSwitchSourceHeader() end)
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
    'rafamadriz/friendly-snippets',
    'nvim-flutter/flutter-tools.nvim'
  },
  config = config
}
