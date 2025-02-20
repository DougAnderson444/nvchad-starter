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

      -- Function to toggle Rust target
      -- local function toggle_rust_target()
      --   -- Get current rust-analyzer client using new API
      --   local rust_analyzer = vim.lsp.get_clients({
      --     name = "rust-analyzer",
      --   })[1]
      --
      --   -- Check if rust-analyzer is running
      --   if not rust_analyzer then
      --     vim.notify("rust-analyzer is not running", vim.log.levels.ERROR)
      --     return
      --   end
      --
      --   -- Get current settings with nil checks
      --   local current_settings = rust_analyzer.config.settings or {}
      --   if not current_settings["rust-analyzer"] then
      --     current_settings["rust-analyzer"] = {}
      --   end
      --   if not current_settings["rust-analyzer"].cargo then
      --     current_settings["rust-analyzer"].cargo = {}
      --   end
      --
      --   -- Get current target or default to empty string
      --   local current_target = current_settings["rust-analyzer"].cargo.target or ""
      --
      --   -- Toggle between wasm and default target
      --   local new_target
      --   if current_target == "wasm32-unknown-unknown" then
      --     new_target = "" -- Reset to default target
      --     vim.notify("Switched to default target", vim.log.levels.INFO)
      --   else
      --     new_target = "wasm32-unknown-unknown"
      --     vim.notify("Switched to WebAssembly target", vim.log.levels.INFO)
      --   end
      --
      --   -- Update the target
      --   current_settings["rust-analyzer"].cargo.target = new_target
      --
      --   -- Apply new settings safely
      --   rust_analyzer.config.settings = current_settings
      --
      --   -- Notify rust-analyzer of configuration change
      --   local bufnr = vim.api.nvim_get_current_buf()
      --   vim.lsp.buf_notify(bufnr, "workspace/didChangeConfiguration", { settings = current_settings })
      --
      --   -- Restart rust-analyzer to ensure changes take effect
      --   vim.cmd "LspRestart rust-analyzer"
      -- end

      -- Create the user command
      -- vim.api.nvim_create_user_command("RustTargetToggle", toggle_rust_target, {
      --   desc = "Toggle between default and wasm32-unknown-unknown targets for Rust",
      -- })
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
      vim.keymap.set("n", "<leader>ra", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.buf.code_action, {
        border = "rounded",
      })

      vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = "#ff7070" })

      -- vim.keymap.set(
      --   "n",
      --   "<leader>rt",
      --   ":RustTargetToggle<CR>",
      --   { noremap = true, silent = true, desc = "Toggle Rust target" }
      -- )

      -- <leader>trl to toggle rust target to linux
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
          target = vim.g.rust_analyzer_cargo_target, -- nil, -- "wasm32-unknown-unknown",
          allFeatures = true,
          features = "all",
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
          ignored = {
            -- ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
      },
    },
  },
}

return opts
