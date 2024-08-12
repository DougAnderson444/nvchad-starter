local opts = {
  tools = {
    float_win_config = {
      border = "rounded",
    },
    -- https://www.lazyvim.org/extras/lang/rust
    on_initialized = function()
      vim.cmd [[
                augroup RustLSP
                  autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                  autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                  autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                augroup END
              ]]
      -- format on save. https://www.jvt.me/posts/2022/03/01/neovim-format-on-save/
      -- vim.cmd [[autocmd BufWritePre *.rs lua vim.lsp.buf.format()]]
    end,
  },
  server = {
    on_attach = function(_, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- Hover actions
      vim.keymap.set("n", "<C-space>", function()
        vim.cmd.RustLsp { "hover", "actions" }
      end, opts)

      vim.keymap.set("n", "<leader>ca", function()
        vim.cmd.RustLsp "codeAction"
      end, { desc = "Code Action", buffer = bufnr })

      vim.keymap.set("n", "<leader>a", function()
        vim.cmd.RustLsp "codeAction"
      end, { desc = "Code Action", buffer = bufnr })

      vim.keymap.set("n", "<leader>dr", function()
        vim.cmd.RustLsp "debuggables"
      end, { desc = "Rust Debuggables", buffer = bufnr })

      -- Toggle inlay hints
      vim.keymap.set("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
      end, { desc = "Inlay hints Toggle" })

      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      vim.keymap.set("n", "<leader>ra", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.buf.code_action, {
        border = "rounded",
      })
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        -- Add clippy lints for Rust.
        checkOnSave = true,
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
      },
    },
  },
}

return opts
