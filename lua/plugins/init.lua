return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
    opts = require "configs.rustaceanvim",
    config = function(_, opts)
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
    opts = function()
      local conf = require "nvchad.configs.telescope"
      conf.defaults.mappings.i = {
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<Esc>"] = require("telescope.actions").close,
      }
      conf.defaults.file_ignore_patterns = { "node_modules/", ".git", "docs/", "target/", "package-lock.json" }

      return conf
    end,
  },

  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },

  -- {
  --   "saecki/crates.nvim",
  --   tag = "stable",
  --   config = function()
  --     require("crates").setup {
  --       completion = {
  --         cmp = {
  --           enabled = true,
  --         },
  --         crates = {
  --           enabled = true, -- disabled by default
  --           max_results = 8, -- The maximum number of search results to display
  --           min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
  --         },
  --       },
  --     }
  --   end,
  -- },
  --
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
          completion = {
            cmp = { enabled = true },
            crates = {
              enabled = true, -- disabled by default
              max_results = 8, -- The maximum number of search results to display
              min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
            },
            lsp = {
              enabled = true,
              on_attach = function(client, bufnr)
                -- the same on_attach function as for your other lsp's
                local nvlsp = require "nvchad.configs.lspconfig"
                nvlsp.on_attach(client, bufnr)
              end,
              actions = true,
              completion = true,
              hover = true,
            },
          },
        },
      },
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "crates" })
      table.insert(opts.sources, { name = "tailwindcss" })
      -- opts.completion = opts.completion or {}
      -- opts.completion.completeopt = "menu,menuone,noselect"
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
      },
    },
  },

  -- { -- large language model aka free copilot.
  --   "huggingface/llm.nvim",
  --   lazy = false,
  --   opts = {
  --     -- cf Setup
  --     model = "starcoder2:latest",
  --     backend = "ollama",
  --     url = "http://localhost:11434", -- llm-ls uses "/api/generate"
  --     tokens_to_clear = { "<|endoftext|>" },
  --     -- cf https://github.com/ollama/ollama/blob/main/docs/api.md#parameters
  --     request_body = {
  --       -- Modelfile options for the model you use
  --       options = {
  --         temperature = 0.2,
  --         top_p = 0.95,
  --       },
  --     },
  --     fim = {
  --       enabled = true,
  --       prefix = "<fim_prefix>",
  --       middle = "<fim_middle>",
  --       suffix = "<fim_suffix>",
  --     },
  --     lsp = {
  --       bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
  --     },
  --     context_window = 8192,
  --     enable_suggestions_on_startup = true,
  --     enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
  --   },
  -- },
}
