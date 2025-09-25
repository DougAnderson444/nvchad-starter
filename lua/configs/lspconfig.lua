-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
-- taplo was installed via `cargo install`, so mason is not needed for it
local servers = { "html", "cssls", "taplo", "svelte", "pest_ls", "yamlls" }
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
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

lspconfig.yamlls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "**/.gitlab-ci.yml",
      },
      customTags = {
        "!reference sequence", -- Add GitLab's custom YAML tags
      },
      validate = true,
    },
  },
}

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
  cmd = { "tailwindcss-language-server", "--stdio" }, -- Remove "BufEnter" (it's not a valid parameter)
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
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
  settings = {
    tailwindCSS = {
      includeLanguages = {
        rust = "html", -- This is the correct way to map Rust to HTML
      },
      classAttributes = {
        "class",
        "className",
        "classList",
        "ngClass",
      },
      experimental = {
        classRegex = {
          -- This pattern specifically targets Dioxus class: "..." syntax
          'class:\\s*"([^"]*)"',
          'class=\\s*"([^"]*)"',
          -- Additional patterns for other variations
          'classes:\\s*"([^"]*)"',
          'class_name:\\s*"([^"]*)"',
        },
      },
      validate = true,
    },
  },
  -- Include Rust project identifiers
  root_dir = lspconfig.util.root_pattern(
    "tailwind.config.js",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.ts",
    "windi.config.ts",
    "Cargo.toml" -- Add this to detect Rust projects
  ),
}

vim.lsp.buf.hover { border = "rounded" }
vim.lsp.buf.signature_help { border = "rounded" }
