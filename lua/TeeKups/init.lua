require('TeeKups.set')
require('TeeKups.remap')
require('TeeKups.lazy_init')

-- colors
vim.cmd.colorscheme "catppuccin"
--vim.cmd.colorscheme "dracula"
--vim.cmd.colorscheme "gruvbox"
--vim.cmd.colorscheme "rose-pine-moon"
--vim.cmd.colorscheme "tokyonight"

local augroup = vim.api.nvim_create_augroup
local TeeKupsGroup = augroup('TeeKups', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function reload(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

-- highlight yanked text for a moment
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- run formatter on write
autocmd('BufWritePre', {
    group = TeeKupsGroup,
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end
})

-- automatically delete trailing whitespace
autocmd({"BufWritePre"}, {
    group = TeeKupsGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]]
})

-- lsp keymaps
autocmd('LspAttach', {
    group = TeeKupsGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd",           function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K",            function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws",  function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd",   function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca",  function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr",  function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn",  function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<C-h>",        function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("i", "[d",           function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d",           function() vim.diagnostic.goto_prev() end, opts)
    end
})

-- file browser stuff
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 1
vim.g.netrw_winsize = 25
