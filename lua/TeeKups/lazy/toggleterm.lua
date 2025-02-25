return {
    'akinsho/toggleterm.nvim',
    config = function()
        require('toggleterm').setup({
            open_mapping = '<leader>sc',
            direction = 'float',
        })
    end
}
