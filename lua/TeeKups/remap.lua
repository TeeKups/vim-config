-- space as <leader>
vim.g.mapleader = " "

-- Normal mode
-- Uncomment if not using vim-tree
--vim.keymap.set('n', '<leader>pv', vim.cmd.Explore)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
---- Yank until end of line
vim.keymap.set("n", "Y", "yg$")
---- Keep cursor in same place when catenating lines
vim.keymap.set("n", "J", "mzJ`z")
---- Center screen after moving half a page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
---- Center when jumping; zv opens folded lines
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
---- When pressing *, search and highlight all occurrences of current word but do not jump
vim.keymap.set("n", "*", ":let @/ = '\\<'.expand('<cword>').'\\>' | set hlsearch<C-M>")
---- Format buffer according to lsp rules
vim.keymap.set("n", "<leader>f", function() require("conform").format() end)
---- Faster quickfix
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
---- Make current file executable by all
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
---- Yank to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
---- What the fuck is Q
vim.keymap.set("n", "Q", "<nop>")
---- search and replace word under cursor, methinks
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Visual mode
---- Move selected line and autoindent
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
---- Delete and paste
vim.keymap.set("x", "<leader>p", "\"_dP")
---- Yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- Delete without yanking
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
vim.keymap.set({"n", "v"}, "<leader>D", [["_D]])

-- Insert mode
---- Ctrl+C = Esc
vim.keymap.set("i", "<C-c>", "<Esc>")

---- Fix for lazy shift-pinkie when writing or closing
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
