local opts = require "nvchad.configs.nvimtree"

-- show files in .gitignore
opts.git = opts.git or {}
opts.git.ignore = false

-- show dotfiles
opts.filters = opts.filters or {}
opts.filters.dotfiles = false -- set the false to show dotfiles

return opts
