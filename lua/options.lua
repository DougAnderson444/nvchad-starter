require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

vim.diagnostic.config { float = { border = "rounded", source = "if_many" } }

vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "term://*",
  callback = function()
    vim.cmd "startinsert"
  end,
})

local augroup = vim.api.nvim_create_augroup("SvelteComments", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "svelte",
  group = augroup,
  callback = function()
    vim.bo.commentstring = "<!-- %s -->"
  end,
})
