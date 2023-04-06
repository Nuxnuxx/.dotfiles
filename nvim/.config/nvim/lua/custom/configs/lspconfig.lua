local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

lspconfig.rust_analyzer.setup({ on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"rust"},
  root_dir = lspconfig.util.root_pattern("Cargo.toml"),
})

lspconfig.phpactor.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"php"},
})

lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  init_options = { hostInfo = "neovim" },
  root_pattern = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  single_file_support = true,
})

lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  init_options = { configurationSection = { "html", "css", "javascript" }, embeddedLanguages = { css = true, javascript = true }, provideFormatter = true },
  single_file_support = true,
})

lspconfig.emmet_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "emmet-ls", "--stdio" },
  filetypes = { "html" },
  single_file_support = true,
})

lspconfig.cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  settings = { css = { validate = true }, less = { validate = true }, scss = { validate = true } },
  single_file_support = true,
})

lspconfig.jsonls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = { provideFormatter = true },
  single_file_support = true,
})

lspconfig.vuels.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "vls" },
  filetypes = { "vue" },
  init_options = { config = { css = {}, emmet = {}, html = { suggest = {} }, javascript = { format = {} }, stylusSupremacy = {}, typescript = { format = {} }, vetur = { completion = { autoImport = false, tagCasing = "kebab", useScaffoldSnippets = false }, format = { defaultFormatter = { js = "none", ts = "none" }, defaultFormatterOptions = {}, scriptInitialIndent = false, styleInitialIndent = false }, useWorkspaceDependencies = false, validation = { script = true, style = true, template = true } } } },
  root_pattern = {"package.json", "vue.config.js" },
  single_file_support = true,
})
