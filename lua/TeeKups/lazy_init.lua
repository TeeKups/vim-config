-- Try to install from local data
if vim.loop.fs_stat(os.getenv('HOME') .. "/.config/nvim/share") then
    local fontpath = os.getenv('HOME') .. "/.local/share/fonts/ttf/NerdFontsSymbolsOnly"
    if not vim.loop.fs_stat(fontpath) then
        vim.fn.system({
    	"mkdir",
    	"-p",
    	os.getenv('HOME') .. "/.local/share/fonts/ttf",
        })
        vim.fn.system({
    	"ln",
    	"-s",
    	os.getenv('HOME') .. "/.config/nvim/share/fonts/ttf/NerdFontsSymbolsOnly",
    	os.getenv('HOME') .. "/.local/share/fonts/ttf/NerdFontsSymbolsOnly",
        })
        vim.fn.system({
    	"fc-cache",
    	"-f",
    	"-v",
        })
    end
    
    local datapath = os.getenv('HOME') .. "/.local/share/nvim"
    if not vim.loop.fs_stat(datapath) then
        vim.fn.system({
    	"ln",
    	"-s",
    	os.getenv('HOME') .. "/.config/nvim/share/nvim",
    	os.getenv('HOME') .. "/.local/share/nvim",
        })
    end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
    spec = "TeeKups.lazy",
    change_detection = { notify = false }
})
