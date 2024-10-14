-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

local utils = require "nvchad.stl.utils"
local sep_r = " "

-- local colors = require("base46").get_theme_tb "base_30"

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
      -- add path to file portion of statusline
      file = function()
        local x = utils.file()
        local name = x[2] .. " "
        local path = vim.fn.expand "%:p" -- vim.api.nvim_buf_get_name(0):match "^.*/"
        if not path then
          return "%#St_file# " .. x[1] .. name .. "%#St_file_sep#" .. sep_r
        end
        path = path:sub(2) -- remove leading "/" from path
        return "%#St_file#" .. path .. "%#St_file_sep#" .. sep_r
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
    -- Rust overrides:
    -- ["@lsp.type.parameter"] = { fg = "red" },
    -- ["@lsp.type.function"] = { fg = "green" },
  },
  hl_add = {
    FloatBorder = { fg = "green" },
    NormalFloat = { fg = "green" },
    NvimTreeCursorLine = { bg = "lightblue" },
  },
}

return M
