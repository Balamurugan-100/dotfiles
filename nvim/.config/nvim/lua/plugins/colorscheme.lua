return {
  -- LazyVim already sets this as the default colorscheme,
  -- so we only need to configure it. `transparent` also clears
  -- SignColumn/FoldColumn/LineNr, so the left edge stays fully see-through.
  { "folke/tokyonight.nvim", opts = { style = "moon", transparent = true } },
}
