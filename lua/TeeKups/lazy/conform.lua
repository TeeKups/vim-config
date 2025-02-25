return {
    "stevearc/conform.nvim",
    name = "conform",
    opts = {},
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                go = { "goimports", "gofmt" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                css = { "prettierd", "prettier", stop_after_first = true },
                graphql = { "prettierd", "prettier", stop_after_first = true },
                json = { "prettierd", "prettier", stop_after_first = true },
                markdown = { "prettierd", "prettier", stop_after_first = true },
                html = { "prettierd", "prettier", stop_after_first = true },
                python = { "black", stop_after_first = true },
                ["_"] = { "trim_whitespace" },
            }
        })
    end
}
