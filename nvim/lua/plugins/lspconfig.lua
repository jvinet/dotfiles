return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.diagnostics.virtual_text = false
  end,
  setup = {
    -- For all servers
    ["*"] = function(server, opts)
      opts.on_attach = function(client, bufnr)
        -- Disable diagnostics initially
        vim.diagnostic.disable(bufnr)

        -- Re-enable only on save
        vim.api.nvim_create_autocmd("BufWritePost", {
          buffer = bufnr,
          callback = function()
            vim.diagnostic.enable(bufnr)
            vim.diagnostic.reset(nil, bufnr) -- optional: clear previous diagnostics
            vim.lsp.buf.clear_references()
            vim.lsp.buf.document_highlight()
          end,
        })
      end
      require("lspconfig")[server].setup(opts)
      return true
    end,
  },
}
