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
            default = "claude-3.7-sonnet",
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
    -- gemini = function()
    --   return require("codecompanion.adapters").extend("gemini", {
    --     env = {
    --       api_key = "cmd:op read op://personal/Gemini_API/credential --no-newline",
    --     },
    --   })
    -- end,
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        schema = {
          num_ctx = {
            default = 20000,
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "copilot",
      roles = {
        user = "DougAnderson444",
      },
    },
    inline = {
      adapter = "copilot",
    },
  },
}

return options
