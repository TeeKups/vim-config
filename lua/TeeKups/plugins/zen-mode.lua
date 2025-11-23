return {
    "folke/zen-mode.nvim",
    name = "zen-mode",
    config = function()
        require("zen-mode").setup({
            window = {
                backdrop = 0, -- Do not modify backdrop
            },
            plugins = {
                options = {
                    enabled = true,
                    laststatus = 3, -- keep global status line
                },
            }
        })
        vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle Zen Mode"})
        vim.api.nvim_set_hl(0, "ZenBg", { ctermbg = 0})
    end
}
