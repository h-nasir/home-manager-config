return {
    {"nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" }},
    {"navarasu/onedark.nvim"},
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "java", "lua", "vim", "vimdoc", "javascript", "html", "python" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },  
            })
        end
    },
    {"neovim/nvim-lspconfig"},
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        -- opts = {
        --     sources = {
        --         name = 'nvim_lsp'
        --     },
        -- },
    },
    {"mbbill/undotree"},
}
