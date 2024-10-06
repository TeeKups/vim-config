-- ??? this is the default ???
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'

-- line numbers
vim.opt.number = true
-- no disgusting relative line numbers
vim.opt.relativenumber = false

-- Use 4 spaces in place of tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Autoindent applies the indent of the current line to the next line
-- while smartindent takes into account the  syntax/style of the code/text being edited
-- Autoindent and smartindent should be used together
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Open new splits to below right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Show tabs as >, and interpunct in place of nbsp and trailing space
vim.opt.listchars = 'tab:> ,nbsp:·,trail:·'
vim.opt.list = true

-- Disable mouse
vim.opt.mouse = ''

-- Case insensitive search
vim.opt.smartcase = true

-- Incremental search shows matches while you're writing
vim.opt.incsearch = true

-- No highlight on search
vim.opt.hlsearch = false

--- No backups or swap files
vim.opt.backup = false
vim.opt.swapfile = false

-- Preserve undo history between sessions
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir"
vim.opt.undofile = true

-- Disable error bells
vim.opt.errorbells = false

-- File format and encoding
vim.opt.fileformat = "unix"
vim.opt.encoding = "utf-8"

-- Disable wrapping
vim.opt.wrap = false

-- Show a few lines below and above cursor
vim.opt.scrolloff = 5

-- Area for LSP to draw funny icons in
vim.opt.signcolumn = "yes"

-- indicator for long lines
vim.opt.colorcolumn = "80"

vim.opt.termguicolors = true
