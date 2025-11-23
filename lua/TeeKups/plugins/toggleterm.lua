return {
    'akinsho/toggleterm.nvim',
    config = function()
        require('toggleterm').setup({
            open_mapping = '<leader>sc',
            direction = 'float',
            insert_mappings = false,  -- WHY IS THIS NOT THE DEFAULT?!?!?!?!
        })
    end
}
