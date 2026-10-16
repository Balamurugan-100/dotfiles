require("luasnip").setup({})

require("blink.cmp").setup({
  keymap = {
    preset = "none",

    ["<C-Space>"] = {
      "show",
      "show_documentation",
      "hide_documentation",
    },

    ["<CR>"] = {
      "accept",
      "fallback",
    },

    ["<C-n>"] = {
      "select_next", "fallback",
    },

    ["<C-p>"] = {
      "select_prev",
      "fallback",
    },

    ["<C-e>"] = {
      "hide",
      "fallback",
    },

    ["<C-k>"] = {
      "show_signature",
      "hide_signature",
      "fallback",
    },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    documentation = {
      auto_show = true,
    },
  },

  sources = {
    default = {
      "lsp",
      "path",
      "snippets",
    },
  },

  snippets = {
    preset = "luasnip",
  },

  fuzzy = {
    implementation = "lua",
  },

  signature = {
    enabled = true,
  },
})
