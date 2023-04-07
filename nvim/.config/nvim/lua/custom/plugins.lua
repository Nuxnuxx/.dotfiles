local plugins = {
  {
    "neovim/nvim-lspconfig",

     dependencies = {
     "jose-elias-alvarez/null-ls.nvim",
     config = function()
       require "custom.configs.null-ls"
     end,
   },

    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        -- "phpactor",
        "typescript-language-server",
        "emmet_ls",
        "css-lsp",
        "json-lsp",
        "vue-language-server",
        "prettier",
        "rustfmt",
        "shellcheck",
      },
    },
  }
}

return plugins
