return {
  	{
    		'VonHeikemen/lsp-zero.nvim',
    		branch = 'v4.x',
		lazy = true,
    		config = false,
  	},
  	{
    		'williamboman/mason.nvim',
    		lazy = false,
		config = true,
  	},

  	-- Autocompletion
  	{
    		'hrsh7th/nvim-cmp',
    		event = 'InsertEnter',
    		dependencies = {
      			{'L3MON4D3/LuaSnip'},
    		},
		config = function()
		      local cmp = require('cmp')
		      local cmp_select = { behavior = cmp.SelectBehavior.Select }

		      cmp.setup({
			sources = {
			  {name = 'nvim_lsp'},
			},
			mapping = cmp.mapping.preset.insert({
			 	["<C-k>"]     = cmp.mapping.select_prev_item(cmp_select),
				["<C-j>"]     = cmp.mapping.select_next_item(cmp_select),
				["<C-e>"]     = cmp.mapping.confirm( { select = true } ),
				['<C-Space>'] = cmp.mapping.complete(),
			}),
			snippet = {
			  expand = function(args)
			    vim.snippet.expand(args.body)
			  end,
			},
		     })
	    	end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      local lsp_attach = function(client, bufnr)
        local opts = {buffer = bufnr}

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      })

      require('mason-lspconfig').setup({
        ensure_installed = {
		"rust_analyzer",
		"lua_ls",
	},
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        }
      })
    end
  }
}

