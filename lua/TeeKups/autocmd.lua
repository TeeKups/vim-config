local augroup = vim.api.nvim_create_augroup
local TeeKupsGroup = augroup('TeeKups', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

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

