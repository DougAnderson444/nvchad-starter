local chosen_adapter = "copilot" -- "ollama" -- "gemini" --

-- copilot models
local copilot_default_model_chosen = {
  default = "gpt-4.1", -- not premium
  -- Provide other model choices so CodeCompanion can present them in the model picker.
  -- The change_adapter code accepts a models table where keys are model ids and values are
  -- either nil or a table describing the model. Using string keys with nil value makes
  -- CodeCompanion treat the set as a list of strings.
  choices = {
    ["gpt-4.1"] = nil,
    ["gpt-4o"] = nil,
    ["gpt-5"] = nil,
    ["claude-sonnet-4.5"] = nil,
  },
}

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
      -- ensure model choices UI is enabled (default is true, be explicit)
      opts = {
        show_model_choices = true,
      },
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = { default = "gpt-4.1" },
          },
          models = { "gpt-4.1", "gpt-4o", "gpt-5", "claude-sonnet-4.5" },
        })
      end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          schema = {
            model = {
              -- https://cloud.google.com/vertex-ai/generative-ai/docs/models/gemini/2-5-flash-lite#2.5-flash-lite
              default = "gemini-2.5-flash",
              choices = {
                -- https://ai.google.dev/gemini-api/docs/rate-limits#free-tier
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
      qwen_navigator = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          name = "qwen",
          url = "http://localhost:10501/v1/chat/completions",
          schema = {
            model = {
              default = "qwen-coder",
            },
          },
          handlers = {
            -- Tool calling is handled automatically by OpenAI-compatible format
            tools = true,
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
        -- chosen model and chosen adapter passed here
        user = "DougAnderson444 -- " .. chosen_adapter,
      },
    },
    inline = {
      adapter = "gemini",
      model = "gemini-2.5-flash",
    },
  },
}

return options
