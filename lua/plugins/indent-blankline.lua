return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      opts.enabled = false
    end,
    event = "LazyFile",
    main = "ibl",
  },
}
