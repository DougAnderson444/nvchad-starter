local chosen_adapter = "copilot" -- "ollama" -- "gemini" --

local options = {
  display = {
    chat = {
      intro_message = "Doug, Welcome to CodeCompanion ✨! Press ? for options",
      show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
      separator = "─", -- The separator between the different messages in the chat buffer
      show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
      show_settings = false, -- Show LLM settings at the top of the chat buffer?
      show_token_count = true, -- Show the token count for each response?
      start_in_insert_mode = false, -- Open the chat buffer in insert mode?
    },
  },
  adapters = {
    http = {
      -- anthropic = function()
      --   return require("codecompanion.adapters").extend("anthropic", {
      --     env = {
      --       api_key = "cmd:op read op://personal/Anthropic_API/credential --no-newline",
      --     },
      --   })
      -- end,
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "gpt-4.1",
            },
          },
        })
      end,
      -- deepseek = function()
      --   return require("codecompanion.adapters").extend("deepseek", {
      --     env = {
      --       api_key = "cmd:op read op://personal/DeepSeek_API/credential --no-newline",
      --     },
      --   })
      -- end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          schema = {
            model = {
              -- https://cloud.google.com/vertex-ai/generative-ai/docs/models/gemini/2-5-flash-lite#2.5-flash-lite
              default = "gemini-2.5-flash",
              choices = {
                -- https://ai.google.dev/gemini-api/docs/rate-limits#free-tier
                -- model = "gemini-2.5-pro", -- 100 requests per day free
                -- model = "gemini-2.5-flash", -- 250 requests per day free
                -- model = "gemini-2.5-flash-lite-preview-06-17", -- 1k requests per day free
                -- This will merge with the base Gemini choices
                ["gemini-2.5-flash-lite-preview-06-17"] = { opts = { can_reason = true, has_vision = true } },
              },
            },
          },
          env = {
            api_key = function()
              return os.getenv "GEMINI_API_KEY" -- set in ~/.bashrc or ~/.zshrc
            end,
          },
        })
      end,
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          schema = {
            model = {
              -- default = "deepseek-coder-v2:latest", -- best for Rust
              -- default = "deepseek-coder:33b", -- More RAM, but better quality
              default = "codellama:7b", -- very cpu friendly
            },
            num_ctx = {
              default = 20000,
            },
          },
        })
      end,
    },
  },
  strategies = {
    chat = {
      adapter = chosen_adapter,
      roles = {
        user = "DougAnderson444@gmail.com -- " .. chosen_adapter,
      },
    },
    inline = {
      adapter = "gemini",
      model = "gemini-2.5-flash",
    },
  },
}

return options
