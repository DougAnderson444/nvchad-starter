local telescope = require "telescope.builtin"

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
    end,
  },
  server = {
    on_attach = function(_, bufnr)
      -- set rust target and restart LspRestart
      vim.api.nvim_create_user_command("SetRustTarget", function(opts)
        vim.g.rust_analyzer_cargo_target = opts.args
        print("Rust target set to: " .. opts.args)
        vim.cmd "LspRestart"
      end, { nargs = 1 })

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

      vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      vim.keymap.set("n", "<leader>of", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

      vim.keymap.set("n", "<leader>cd", function()
        vim.cmd.RustLsp "renderDiagnostic"
      end, { desc = "Rust Diagnostic", buffer = bufnr })

      vim.keymap.set("n", "<leader>dr", function()
        vim.cmd.RustLsp "debuggables"
      end, { desc = "Rust Debuggables", buffer = bufnr })

      -- Toggle inlay hints
      vim.keymap.set("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
      end, { desc = "Inlay hints Toggle" })

      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      -- gr for get references, but use telescope to display them
      vim.keymap.set("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)
      -- Telescope Call Hierarchy Bindings
      vim.api.nvim_set_keymap(
        "n",
        "<leader>ci",
        '<cmd>lua require("telescope.builtin").lsp_incoming_calls()<CR>',
        { noremap = true, silent = true }
      )

      vim.api.nvim_set_keymap(
        "n",
        "<leader>co",
        '<cmd>lua require("telescope.builtin").lsp_outgoing_calls()<CR>',
        { noremap = true, silent = true }
      )

      vim.lsp.buf.hover { border = "rounded" }
      vim.lsp.buf.signature_help { border = "rounded" }

      vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = "#ff7070" })

      -- toggle rust target to linux
      vim.keymap.set(
        "n",
        "<leader>trl",
        ":SetRustTarget nil<CR>",
        { noremap = true, silent = false, desc = "Rust-Anaylzer target x86_64-unknown-linux-gnu" }
      )

      --<leader>trw to set to wasm32-unknown-unknown
      vim.keymap.set(
        "n",
        "<leader>trw",
        ":SetRustTarget wasm32-unknown-unknown<CR>",
        { noremap = true, silent = false, desc = "Rust-Analyzer target wasm32-unknown-unknown" }
      )
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {
        cargo = {
          allTargets = true,
          -- target = vim.g.rust_analyzer_cargo_target, -- nil, -- "wasm32-unknown-unknown",
          allFeatures = true,
          features = "all",
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
          targetDir = "target/analyzer",
        },
        procMacro = {
          enable = true,
          ignored = {
            -- ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
        -- Ensure rust-analyzer uses the specified targets
        target = {
          "aarch64-unknown-linux-gnu",
          "aarch64-apple-ios",
          "aarch64-apple-ios-sim",
          "x86_64-apple-ios",
        },
      },
    },
  },
}

return opts
