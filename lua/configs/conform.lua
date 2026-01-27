local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    svelte = { "prettierd", "prettier" },
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    toml = { "taplo" },
    dot = { "prettier_dot" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },

  formatters = {
    prettier_dot = {
      command = "/opt/homebrew/bin/prettier",
      args = { "--plugin", "/opt/homebrew/lib/node_modules/prettier-plugin-dot", "--stdin-filepath", "$FILENAME" },
      stdin = true,
    },
  },
}

return options
