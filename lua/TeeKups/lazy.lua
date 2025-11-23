local cache_dir = vim.fn.stdpath('config') .. '/.cache'
local lazypath = cache_dir .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    root = cache_dir .. '/lazy',
    spec = {
        { import = "TeeKups.plugins" },
    },
    change_detection = { notify = false },
    -- disable automatic updates
    checker = { enabled = false },
})
