return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "j-hui/fidget.nvim",

        -- completion
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        'windwp/nvim-autopairs',

        -- snippet sources
        "rafamadriz/friendly-snippets",
    },

    config = function()
        vim.lsp.enable({
            'clangd',
            'cmake',
            'gopls',
            'eslint',
            'pyright',
            'robotframework_ls',
        })

        require("nvim-autopairs").setup({
            event = "InsertEnter",
            config = true,
        })
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        require("luasnip.loaders.from_vscode").lazy_load()
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-Space>'] = cmp.mapping.complete(),
                --['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<CR>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end,
                    s = cmp.mapping.confirm({ select = true }),
                    c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                }),
            }),
            sources = cmp.config.sources({
                { name = 'luasnip' },
                { name = 'nvim_lsp' },
            }, {
                { name = 'buffer' },
            })
        })
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
