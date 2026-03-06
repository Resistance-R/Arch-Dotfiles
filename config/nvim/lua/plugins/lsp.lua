return {
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "ast_grep", "qmlls" },
        })
        end,
    },

    {
        "neovim/nvim-lspconfig",
            config = function()

        -- Keymap
        local on_attach = function(_, bufnr)
            local opts = { buffer = bufnr }

            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end

        local servers = { "lua_ls", "ast_grep", "qmlls" }

        for _, server in ipairs(servers) do
            vim.lsp.config(server, {
                on_attach = on_attach,
        })
      end

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        })

        vim.lsp.config("qmlls", {
            cmd = { "qmlls" },
            filetypes = { "qml" },
        })

        vim.lsp.enable(servers)
      end,
    },
}
