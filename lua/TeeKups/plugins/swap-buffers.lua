return {
    "caenrique/swap-buffers.nvim",
    name = "swap-buffers",
    config = function()
        vim.keymap.set("n", "<leader>wh", function() require('swap-buffers').swap_buffers('h') end)
        vim.keymap.set("n", "<leader>wj", function() require('swap-buffers').swap_buffers('j') end)
        vim.keymap.set("n", "<leader>wk", function() require('swap-buffers').swap_buffers('k') end)
        vim.keymap.set("n", "<leader>wl", function() require('swap-buffers').swap_buffers('l') end)
    end
}
