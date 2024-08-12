local opts = require "nvchad.configs.nvimtree"

-- show files in .gitignore
opts.git = opts.git or {}
opts.git.ignore = false

return opts
