return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          next = "<S-Tab>",
          accept_word = false,
          accept_line = false,
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
        ["*"] = true, -- Enable for all filetypes
      },
    },
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
          ["*"] = true,
        },
      })
    end,
  },
}
