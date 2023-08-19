-- Normal mode
vim.keymap.set('n', '<leader>pv', vim.cmd.Explore)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
---- Yank until end of line
vim.keymap.set("n", "Y", "yg$")
---- Keep cursor in same place when catenating lines
vim.keymap.set("n", "J", "mzJ`z")
---- Center screen after moving half a page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
---- Center when jumping
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
---- When pressing *, search and highlight all occurrences of current word but do not jump
vim.keymap.set("n", "*", ":let @/ = '\\<'.expand('<cword>').'\\>' | set hlsearch<C-M>")
---- Format buffer according to lsp rules
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
---- Faster quickfix
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")
---- Make current file executable by all
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
---- Yank to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
---- Vim-Fugitive (Git)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- Visual mode
---- Move selected line and autoindent
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
---- Delete and paste
vim.keymap.set("x", "<leader>p", "\"_dP")
---- Yank to clipboard
vim.keymap.set("v", "<leader>y", "\"+y")

-- Insert mode
-- Greatest remap ever
vim.keymap.set("i", "<C-c>", "<Esc>")
--

-- Fix for lazy shift-pinkie when writing or closing
local function alias(cmdalias, cmd)
    vim.cmd { cmd = 'cabbrev', args = { cmdalias, cmd } }
end
alias('Q', 'q')
alias('Qa', 'qa')
alias('W', 'w')
alias('Wq', 'wq')
alias('Wqa', 'wqa')

-- When using tabs, only close current tab instead of closing vim with [w]qa
 function Closetab (write)
    if (write)
    then
        vim.cmd.wall()
    end

    if vim.fn['tabpagenr']('$') > 1
    then
        vim.cmd.tabclose()
    else
        vim.cmd.quit()
    end
end
alias('qa', 'lua Closetab(false)')
alias('wqa', 'lua Closetab(true)')
