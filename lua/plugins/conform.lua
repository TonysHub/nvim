return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Extend the default formatters_by_ft with your own custom formatters
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        lua = { "stylua" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "isort", "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        -- go = { "gofmt", "gofumpt" },
        go = { "gofumpt" },
        elixir = { "mix" },
        javascript = { { "prettierd", "prettier" } },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
      })

      return opts
    end,
  },
}
