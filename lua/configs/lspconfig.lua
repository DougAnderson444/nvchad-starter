-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
-- taplo was installed via `cargo install`, so mason is not needed for it
local servers = { "html", "cssls", "taplo" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

lspconfig.taplo.keys = {
  {
    "K",
    function()
      if vim.fn.expand "%:t" == "Cargo.toml" and require("crates").popup_available() then
        require("crates").show_popup()
      else
        vim.lsp.buf.hover()
      end
    end,
    desc = "Show Crate Documentation",
  },
}

lspconfig.tailwindcss.setup {
  cmd = { "tailwindcss-language-server", "--stdio", "BufEnter" },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "css",
    "scss",
    "sass",
    "postcss",
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "svelte",
    "vue",
    "rust",
    "markdown",
  },
  init_options = {
    userLanguages = {
      rust = "html",
    },
  },
  -- Here If any of files from list will exist tailwind lsp will activate.
  root_dir = lspconfig.util.root_pattern(
    "tailwind.config.js",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.ts",
    "windi.config.ts"
  ),
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})
