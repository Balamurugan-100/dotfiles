require("fidget").setup({})
require("mason").setup({})

--------------------------------------------------------------------------------
-- Servers
--------------------------------------------------------------------------------

local servers = {
  clangd = {},
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  ts_ls = {},

  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false

      if client.workspace_folders then
        local path = client.workspace_folders[1].name

        if path ~= vim.fn.stdpath("config")
          and (
            vim.uv.fs_stat(path .. "/.luarc.json")
            or vim.uv.fs_stat(path .. "/.luarc.jsonc")
          )
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend(
        "force",
        client.config.settings.Lua,
        {
          runtime = {
            version = "LuaJIT",
            path = {
              "lua/?.lua",
              "lua/?/init.lua",
            },
          },

          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend(
              "force",
              vim.api.nvim_get_runtime_file("", true),
              {
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              }
            ),
          },
        }
      )
    end,

    settings = {
      Lua = {
        format = {
          enable = false,
        },
      },
    },
  },
}

--------------------------------------------------------------------------------
-- Install Servers
--------------------------------------------------------------------------------

require("mason-tool-installer").setup({
  ensure_installed = vim.tbl_keys(servers),
})

--------------------------------------------------------------------------------
-- LSP Attach
--------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("custom-lsp", { clear = true }),

  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local map = function(keys, func, desc, mode)
      vim.keymap.set(mode or "n", keys, func, {
        buffer = event.buf,
        desc = "LSP: " .. desc,
      })
    end

    --------------------------------------------------------------------------
    -- Navigation
    --------------------------------------------------------------------------

    map("gd", vim.lsp.buf.definition, "Definition")
    map("gD", vim.lsp.buf.declaration, "Declaration")
    map("gi", vim.lsp.buf.implementation, "Implementation")
    map("gr", vim.lsp.buf.references, "References")
    map("gt", vim.lsp.buf.type_definition, "Type Definition")

    --------------------------------------------------------------------------
    -- Information
    --------------------------------------------------------------------------

    map("K", vim.lsp.buf.hover, "Hover")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

    --------------------------------------------------------------------------
    -- Actions
    --------------------------------------------------------------------------

    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })

    --------------------------------------------------------------------------
    -- Document Highlight
    --------------------------------------------------------------------------

    if client and client:supports_method("textDocument/documentHighlight") then
      local group =
        vim.api.nvim_create_augroup("custom-lsp-highlight", { clear = false })

      vim.api.nvim_create_autocmd(
        { "CursorHold", "CursorHoldI" },
        {
          group = group,
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        }
      )

      vim.api.nvim_create_autocmd(
        { "CursorMoved", "CursorMovedI" },
        {
          group = group,
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        }
      )
    end

    --------------------------------------------------------------------------
    -- Inlay Hints
    --------------------------------------------------------------------------

    if client and client:supports_method("textDocument/inlayHint") then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
        )
      end, "Toggle Inlay Hints")
    end
  end,
})

--------------------------------------------------------------------------------
-- Enable Servers
--------------------------------------------------------------------------------

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

