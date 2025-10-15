return {
  "saghen/blink.cmp",
  -- Make blink.cmp toggleable
  opts = function(_, opts)
    vim.b.completion = true

    Snacks.toggle({
      name = "Completion",
      get = function()
        return vim.b.completion
      end,
      set = function(state)
        vim.b.completion = state
      end,
    }):map("<leader>uk")

    opts.enabled = function()
      return vim.b.completion ~= false
    end

    -- Disable preselect and autocomplete
    opts.completion = opts.completion or {}
    opts.completion.list = opts.completion.list or {}
    opts.completion.list.selection = {
      preselect = false, -- Do not preselect
      auto_insert = false, -- Do not auto insert
    }
    return opts
  end,
}
