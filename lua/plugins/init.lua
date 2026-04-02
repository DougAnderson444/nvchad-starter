return {

  "nvim-lua/plenary.nvim",

  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },

  {
    "nvchad/base46",
    lazy = true,
    branch = "v3.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  -- env loading
  {
    "tpope/vim-dotenv",
    config = function()
      require("dotenv").setup()
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    -- The custom config function is removed.
    -- Ensure your lua/configs/lspconfig.lua file is updated to use vim.lsp.config()
    -- instead of the deprecated require('lspconfig') API.
    -- The configurations themselves might now be automatically discovered by vim.lsp.config()
    -- if they are placed in lua/lsp/ or provided by this plugin in a discoverable format.
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^7", -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
    opts = require "configs.rustaceanvim",
    config = function(_, opts)
      vim.g.rust_analyzer_cargo_target = nil
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  { -- AI tooling
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    -- opts = overrides.copilot,
    config = function()
      require "configs.copilot"
      -- Mapping tab is already used by NvChad
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      -- The mapping is set to other key, see custom/lua/mappings
      -- or run <leader>ch to see copilot mapping section
    end,
  },

  -- markdown for codecopanion
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    opts = require "configs.rendermarkdown",
  },

  -- code companion
  {
    "olimorris/codecompanion.nvim",
    config = true,
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = require "configs.codecompanion",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        -- web dev
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "svelte",
        "toml",
        "ron", -- rust object notation
        "yaml",
        -- low level
        "rust",
        "markdown",

        -- custom parser
        "wit",
      },
    },
  },

  { -- terminal
    "akinsho/toggleterm.nvim",
    lazy = false, -- TODO: To get things rolling, load it right away
    version = "*",
    config = function()
      require "configs.toggleterm"
    end,
  },

  { --override nvChad's telescope settings
    "nvim-telescope/telescope.nvim",
    opts = require "configs.telescope",
  },

  { -- for just files
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },

  { --override nvChad's nvim-tree settings
    "nvim-tree/nvim-tree.lua",
    opts = require "configs.nvimtree",
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "saecki/crates.nvim",
        tag = "stable",
        event = { "BufRead Cargo.toml" },
        opts = {
          completion = {
            cmp = { enabled = true },
            crates = {
              enabled = true, -- disabled by default
              max_results = 8, -- The maximum number of search results to display
              min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
            },
          },
        },
      },
    },
    opts = function(_, opts)
      local cmp = require "cmp"
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "crates" })
      table.insert(opts.sources, { name = "tailwindcss" })
      opts.completion = opts.completion or {}
      opts.completion.completeopt = "menu,menuone,noselect,noinsert"
      -- Override NvChad default Mapping
      opts.mapping = opts.mapping or {}
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
      })
      return opts
    end,
  },

  { -- Mason is used to help install LSP servers, formatters, linters, and debug adapters.
    "williamboman/mason.nvim",
    opts = {
      -- call :MasonInstallAll
      ensure_installed = {
        "prettier",
        "svelte-language-server",
        "codelldb",
        "tailwindcss-language-server",
        "dot-language-server",
        "yaml-language-server",
        "pest-language-server",
      },
    },
  },

  -- pest syntax highlighting
  {
    "pest-parser/pest.vim",
    ft = "pest",
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Use lcc as the claude binary so llama-server auto-starts when toggling Claude
      terminal_cmd = vim.fn.expand "~/bin/lcc",
    },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
