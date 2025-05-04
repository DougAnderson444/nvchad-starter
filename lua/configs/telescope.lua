local conf = require "nvchad.configs.telescope"
conf.defaults.mappings.i = {
  ["<C-j>"] = require("telescope.actions").move_selection_next,
  ["<Esc>"] = require("telescope.actions").close,
}
conf.defaults.file_ignore_patterns = { "node_modules/", ".git", "docs/", "target/", "package-lock.json" }

-- no border
conf.defaults.border = false

return conf
