require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls", "bashls" }
vim.lsp.enable(servers)

local lspconfig = require('lspconfig')

-- Bash
lspconfig.bashls.setup({})

-- Markdown
lspconfig.marksman.setup({})

-- PowerShell
lspconfig.powershell_es.setup({
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
})

-- read :h vim.lsp.config for changing options of lsp servers
