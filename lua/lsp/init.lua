local lspconfig = require 'lspconfig'
local cmp = require 'cmp'
local snippy = require 'snippy'
local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

-- Setup autopairs
require "nvim-autopairs".setup {}

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),

	callback = function(ev)
		local opts = { buffer = ev.buf }

		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

		vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, opts)

		vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)

		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

		vim.keymap.set({ 'n', 'v' }, '<leader>.', vim.lsp.buf.code_action, opts)

		vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<leader>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)

		vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
	end,
})

-- Servers
lspconfig.clangd.setup {
	cmd = {
		'clangd',
		'--header-insertion-decorators',
		'--completion-style=bundled',
		'--clang-tidy',
		'--background-index'
	},

	root_dir = vim.loop.cwd,
	capabilities = capabilities
}

lspconfig.tsserver.setup {
	capabilities = capabilities
}

lspconfig.cssls.setup {
	cmd = {
		'css-languageserver',
		'--stdio'
	},

	capabilities = capabilities
}

-- Completion
cmp.setup {
	snippet = {
		expand = function (args)
			snippy.expand_snippet(args.body)
		end
	},

	window = {
		documentation = cmp.config.window.bordered(),
	},

	enabled = function()
		local context = require 'cmp.config.context'

		if vim.api.nvim_get_mode().mode == 'c' then
			return true
		else
			return not context.in_treesitter_capture("comment") 
				   and not context.in_syntax_group("Comment")
		end
	end,

	mapping = vim.tbl_deep_extend('force', cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm { select = false },
	}), {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif snippy.can_expand_or_advance() then
				snippy.expand_or_advance()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif snippy.can_jump(-1) then
				snippy.previous()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
		{ name = 'buffer' }
	}
}

-- insert ( when selecting method
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
