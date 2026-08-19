return {
  "saghen/blink.cmp",
  version = "v0.*",
  dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
  opts = {
    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      menu = {
        border = "rounded",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
        },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    signature = {
      enabled = true,
      window = { border = "rounded" }
    },
  },
}
