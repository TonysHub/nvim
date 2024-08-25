return {
  "gbprod/yanky.nvim",
  keys = {
    { "<leader>p", false }, -- Disable the default mapping for <leader>p if it exists
  },
  opts = function(_, opts)
    opts.highlight = { on_yank = false, timer = 30 }
    return opts
  end,
}
