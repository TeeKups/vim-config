return {
    "folke/trouble.nvim",
    opts = {
        win = { type = "split", position="right" ,}
    },
    cmd = "Trouble",
    keys = {
        {
            "<leader>tt",
            "<cmd> Trouble diagnostics toggle<CR>",
            desc = "Diagnostics (Trouble)",
        },
    }
}
