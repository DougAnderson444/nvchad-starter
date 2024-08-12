-- require("nvchad.configs.cmp").defaults()
-- local opts = require "cmp"
local opts = require "nvchad.configs.cmp"

-- extned cmp_options.sources to add { name = "crates" }
opts.sources = vim.tbl_extend("keep", opts.sources, {
  { name = "crates" },
})

return opts
