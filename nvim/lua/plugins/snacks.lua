return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          layout = {
            -- Hide the search box until focused with '/'
            auto_hide = { "input" },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        -- Check for active picker. If found, focus it instead of creating a
        -- new one.
        local cur_picker = Snacks.picker.get({ source = "explorer" })[1]
        if cur_picker then
          cur_picker:focus()
        else
          Snacks.explorer({ cwd = LazyVim.root() })
        end
      end,
      desc = "Explorer Snacks (root dir)",
      remap = true,
    },
  },
}
