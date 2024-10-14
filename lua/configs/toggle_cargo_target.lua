local M = {}

M.targets = { "wasm32-unknown-unknown", nil } -- nil represents the default target
M.current_index = 2 -- Start with the default target (nil)

function M.toggle_cargo_target()
  M.current_index = (M.current_index % #M.targets) + 1
  local new_target = M.targets[M.current_index]

  -- Get the rust-analyzer client
  local rust_analyzer = vim.lsp.get_clients({ name = "rust_analyzer" })[1]

  if rust_analyzer then
    -- Ensure the settings structure exists
    rust_analyzer.config.settings = rust_analyzer.config.settings or {}
    rust_analyzer.config.settings["rust-analyzer"] = rust_analyzer.config.settings["rust-analyzer"] or {}
    rust_analyzer.config.settings["rust-analyzer"].cargo = rust_analyzer.config.settings["rust-analyzer"].cargo or {}

    -- Update the rust-analyzer settings
    rust_analyzer.config.settings["rust-analyzer"].cargo.target = new_target

    -- Notify the server of the configuration change
    rust_analyzer.notify("workspace/didChangeConfiguration", { settings = rust_analyzer.config.settings })

    -- Notify the user
    local message = new_target and ("Cargo target set to: " .. new_target) or "Using default cargo target"
    vim.notify(message, vim.log.levels.INFO)
  else
    vim.notify("rust-analyzer client not found", vim.log.levels.ERROR)
  end
end

return M
