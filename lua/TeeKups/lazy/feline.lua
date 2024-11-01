return {
    "famiu/feline.nvim",
    name = "feline",
    config = function()
        local ctp_feline = require('catppuccin.groups.integrations.feline')
        require("feline").setup({
            components = ctp_feline.get(),
        })
    end
}
