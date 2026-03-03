return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require('nvim-treesitter').install({
            "c", "lua", "python", "qml"
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "c", "lua", "python", "qml" },
            callback = function() vim.treesitter.start() end,
        })
    end,
}
