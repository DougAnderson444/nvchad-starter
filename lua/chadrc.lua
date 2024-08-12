-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

local utils = require "nvchad.stl.utils"
local sep_r = " "

M.ui = {
  FloatBorder = { fg = "green" }, -- works
  NormalFloat = { fg = "green" }, -- works
  hl_add = {
    FloatBorder = { fg = "green" }, -- works
    NormalFloat = { fg = "green" }, -- works
    NvimTreeCursorLine = { bg = "lightblue" },
  },
  telescope = {
    style = "bordered",
  },
  statusline = {
    -- default sequence: "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor"
    modules = {
      mode = function()
        if not utils.is_activewin() then
          return "FLAME"
        end

        local modes = utils.modes
        modes["n"][3] = " 󰒂 "
        modes["v"][3] = "  "
        modes["i"][3] = "  "
        modes["t"][3] = "  "
        modes["R"][3] = " 󰓡 "
        modes["r"][3] = " 󰓢 "

        local m = vim.api.nvim_get_mode().mode
        local current_mode = "%#St_" .. modes[m][2] .. "Mode#" .. (modes[m][3] or "  !") .. modes[m][1]
        local mode_sep1 = "%#St_" .. modes[m][2] .. "ModeSep#" .. sep_r
        return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_r
      end,
      cursor = function()
        local cursor = "%#St_pos_icon# %#St_pos_text# %l:%c "
        return cursor
      end,
    },
  },
  cmp = {
    border_color = "green",
  },
}

M.base46 = {
  theme = "chadracula",
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    Cursor = { bg = "pink" }, -- works
    LspReferenceText = { fg = "#ff86d3", bg = "#f1f2f8" },
    LspReferenceRead = { fg = "green", bg = "purple" },
    LspReferenceWrite = { fg = "green", bg = "lightblue" },
    FloatBorder = { fg = "green" },
    NormalFloat = { fg = "green" },
    CmpDocBorder = { fg = "grey" }, -- completion docs border color
  },
  hl_add = {
    FloatBorder = { fg = "green" },
    NormalFloat = { fg = "green" },
    NvimTreeCursorLine = { bg = "lightblue" },
  },
}

return M
