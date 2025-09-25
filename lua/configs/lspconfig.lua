-- load defaults i.e lua_lsp
-- Load NvChad's default LSP configuration, which might set up common servers,
-- global settings, and client capabilities. This should be called first.
require("nvchad.configs.lspconfig").defaults()

-- Get NvChad's LSP configuration helpers (e.g., on_attach, capabilities).
-- These are still relevant as they provide NvChad-specific integration.
local nvlsp = require "nvchad.configs.lspconfig"

-- Helper function to register a server configuration using the new API.
-- This helps in applying common settings like NvChad's on_attach and capabilities.
local function register_lsp_config(server_name, config_opts)
  config_opts = config_opts or {} -- Ensure opts is a table

  -- Define the on_attach handler. It combines NvChad's default handler
  -- with server-specific logic like keymaps.
  local on_attach_handler = function(client, buffer)
    -- Call NvChad's default on_attach handler.
    if nvlsp.on_attach then
      nvlsp.on_attach(client, buffer)
    end

    -- Add server-specific keymaps or other buffer-local configurations here.
    -- This section replaces the old 'lspconfig.server.keys' syntax.
    if server_name == "taplo" then
      -- This replaces the deprecated lspconfig.taplo.keys definition.
      vim.keymap.set("n", "K", function()
        if vim.fn.expand "%:t" == "Cargo.toml" and require("crates").popup_available() then
          require("crates").show_popup()
        else
          vim.lsp.buf.hover()
        end
      end, { buffer = buffer, desc = "Show Crate Documentation" })
    end
    -- Add more server-specific on_attach logic here if needed.
  end

  -- Call the new vim.lsp.config API.
  -- The 'name' field is mandatory.
  vim.lsp.config {
    name = server_name,
    cmd = config_opts.cmd,
    filetypes = config_opts.filetypes,
    root_dir = config_opts.root_dir,
    settings = config_opts.settings,
    on_attach = on_attach_handler,
    capabilities = config_opts.capabilities or nvlsp.capabilities, -- Use NvChad's capabilities if not provided.
    -- 'on_init' is less common with vim.lsp.config directly; its functionality
    -- might be handled by the LSP client itself or within 'on_attach'.
  }
end

-- --- Configuration for specific LSP servers ---

-- Servers that can use a mostly default setup with NvChad's helpers.
-- We replicate the loop from your original configuration.
local common_servers = { "html", "cssls", "taplo", "svelte", "pest_ls", "yamlls" }
for _, server_name in ipairs(common_servers) do
  -- For servers like html, cssls, svelte, pest_ls, we call the helper with defaults.
  -- 'taplo' and 'yamlls' are also listed here, but we will provide more specific
  -- configurations below for them as they had custom settings.
  if server_name ~= "yamlls" and server_name ~= "taplo" then -- Avoid double-registering if specific configs follow
    register_lsp_config(server_name)
  end
end

-- Explicitly configure 'taplo' to ensure custom on_attach logic (keymaps) is applied.
-- If 'taplo' was in the common_servers loop, this call overrides its config
-- to include the specific on_attach logic.
register_lsp_config "taplo"

-- Configure 'yamlls' with custom settings.
-- This replaces the old lspconfig.yamlls.setup call with vim.lsp.config.
vim.lsp.config {
  name = "yamlls",
  on_attach = function(client, buffer)
    -- Call NvChad's default on_attach handler.
    if nvlsp.on_attach then
      nvlsp.on_attach(client, buffer)
    end
    -- No server-specific keymaps for yamlls in the original configuration.
  end,
  capabilities = nvlsp.capabilities, -- Use NvChad's client capabilities.
  settings = {
    yaml = {
      schemas = {
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "**/.gitlab-ci.yml",
      },
      customTags = {
        "!reference sequence", -- Add GitLab's custom YAML tags.
      },
      validate = true,
    },
  },
  -- If yamlls required a specific cmd or root_dir not handled by defaults:
  -- cmd = { "your_yamlls_cmd", "--stdio" },
  -- root_dir = vim.lsp.util.root_pattern("your_root_file"),
}

-- Configure 'tailwindcss' with specific command, filetypes, settings, and root_dir.
-- This replaces the old lspconfig.tailwindcss.setup call.
vim.lsp.config {
  name = "tailwindcss",
  cmd = { "tailwindcss-language-server", "--stdio" }, -- Ensure this matches your installation (e.g., via mason.nvim).
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
        rust = "html", -- Maps Rust files to HTML language for Tailwind CSS parsing.
      },
      classAttributes = {
        "class",
        "className",
        "classList",
        "ngClass",
      },
      experimental = {
        classRegex = {
          'class:\\s*"([^"]*)"',
          'class=\\s*"([^"]*)"',
          'classes:\\s*"([^"]*)"',
          'class_name:\\s*"([^"]*)"',
        },
      },
      validate = true,
    },
  },
  root_dir = vim.lsp.util.root_pattern( -- Use the new utility function.
    "tailwind.config.js",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.ts",
    "windi.config.ts",
    "Cargo.toml" -- Detect Rust projects for Tailwind integration.
  ),
  on_attach = function(client, buffer)
    -- Call NvChad's default on_attach handler.
    if nvlsp.on_attach then
      nvlsp.on_attach(client, buffer)
    end
    -- Add any specific on_attach logic for tailwindcss here if needed.
  end,
  capabilities = nvlsp.capabilities,
}

vim.lsp.buf.hover { border = "rounded" }
vim.lsp.buf.signature_help { border = "rounded" }
