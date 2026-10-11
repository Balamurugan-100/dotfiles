--------------------------------------------------------------------------------
-- lualine.nvim — modern statusline with a translucent (blurred) look
--------------------------------------------------------------------------------

-- tokyonight "moon" palette
local c = {
  bg = "#222436",
  fg = "#c8d3f5",
  dim = "#565f89",
  blue = "#82aaff",
  cyan = "#86e1fc",
  green = "#c3e88d",
  magenta = "#c099ff",
  red = "#ff757f",
  yellow = "#ffc777",
}

-- Only the mode pill has a background, everything else is see-through so the
-- transparent colorscheme (plus winblend) shows through
local function pill(color)
  return { bg = color, fg = c.bg, gui = "bold" }
end

local theme = {
  normal = {
    a = pill(c.blue),
    b = { bg = "NONE", fg = c.blue },
    c = { bg = "NONE", fg = c.fg },
  },
  insert = {
    a = pill(c.green),
    b = { bg = "NONE", fg = c.green },
    c = { bg = "NONE", fg = c.fg },
  },
  visual = {
    a = pill(c.magenta),
    b = { bg = "NONE", fg = c.magenta },
    c = { bg = "NONE", fg = c.fg },
  },
  replace = {
    a = pill(c.red),
    b = { bg = "NONE", fg = c.red },
    c = { bg = "NONE", fg = c.fg },
  },
  command = {
    a = pill(c.yellow),
    b = { bg = "NONE", fg = c.yellow },
    c = { bg = "NONE", fg = c.fg },
  },
  terminal = {
    a = pill(c.cyan),
    b = { bg = "NONE", fg = c.cyan },
    c = { bg = "NONE", fg = c.fg },
  },
  inactive = {
    a = { bg = "NONE", fg = c.dim },
    b = { bg = "NONE", fg = c.dim },
    c = { bg = "NONE", fg = c.dim },
  },
}

-- Attached LSP servers
local function lsp_names()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    table.insert(names, client.name)
  end
  return #names > 0 and "" .. table.concat(names, ", ") or ""
end

require("lualine").setup({
  options = {
    theme = theme,
    globalstatus = true,
    icons_enabled = vim.g.have_nerd_font,

    component_separators = "",
    section_separators = "",

    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },

    always_divide_middle = true,
  },

  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(mode)
          return mode:upper()
        end,
      },
    },

    lualine_b = {
      {
        "branch",
        icon = vim.g.have_nerd_font and "" or "",
      },
      {
        "diff",
        symbols = {
          added = vim.g.have_nerd_font and " " or "+",
          modified = vim.g.have_nerd_font and " " or "~",
          removed = vim.g.have_nerd_font and " " or "-",
        },
      },
    },

    lualine_c = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
          error = vim.g.have_nerd_font and " " or "E:",
          warn = vim.g.have_nerd_font and " " or "W:",
          info = vim.g.have_nerd_font and " " or "I:",
          hint = vim.g.have_nerd_font and " " or "H:",
        },
        diagnostic_color = {
          error = { fg = c.red },
          warn = { fg = c.yellow },
          info = { fg = c.blue },
          hint = { fg = c.green },
        },
      },
      {
        "filename",
        path = 1, -- path relative to cwd
        symbols = {
          modified = " ●",
          readonly = " ",
          unnamed = "[No Name]",
          newfile = "[New]",
        },
      },
    },

    lualine_x = {
      { lsp_names, cond = function() return lsp_names() ~= "" end },
      { "filetype", icon_only = true, padding = { left = 1, right = 1 } },
    },

    lualine_y = {},

    lualine_z = {
      "location",
    },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      "location",
    },
  },

  extensions = {
    "quickfix",
    "lazy",
    "fzf",
    "toggleterm",
  },
})
