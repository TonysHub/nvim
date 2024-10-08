-- return {
--   -- Setup conform for formatting
--   {
--     "stevearc/conform.nvim",
--     config = function()
--       local conform = require("conform")
--       conform.setup({
--         formatters_by_ft = {
--           lua = { "stylua" },
--           python = function(bufnr)
--             if require("conform").get_formatter_info("ruff_format", bufnr).available then
--               return { "isort", "ruff_format" }
--             else
--               return { "isort", "black" }
--             end
--           end,
--           elixir = { "mix" },
--           javascript = { { "prettierd", "prettier" } },
--           typescript = { "prettier" },
--           javascriptreact = { "prettier" },
--           typescriptreact = { "prettier" },
--           svelte = { "prettier" },
--           css = { "prettier" },
--           html = { "prettier" },
--           json = { "prettier" },
--           yaml = { "prettier" },
--           markdown = { "prettier" },
--           graphql = { "prettier" },
--         },
--         format_on_save = {
--           timeout_ms = 1000,
--           lsp_fallback = true,
--           async = true,
--         },
--       })
--
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         pattern = "*",
--         callback = function(args)
--           conform.format({ bufnr = args.buf })
--         end,
--       })
--     end,
--   },
--
--   -- Setup LSP servers with Mason
--   {
--     "neovim/nvim-lspconfig",
--     dependencies = {
--       "williamboman/mason.nvim",
--       "williamboman/mason-lspconfig.nvim",
--       "hrsh7th/cmp-nvim-lsp",
--     },
--     config = function()
--       require("mason").setup()
--       require("mason-lspconfig").setup()
--
--       local servers = {
--         tsserver = {
--           settings = {
--             formatting = true,
--             formatoptions = {
--               tabSize = 2,
--               useTabs = false,
--             },
--           },
--         },
--         efm = {
--           init_options = { documentFormatting = true },
--           filetypes = { "javascript", "javascriptreact", "jsx" },
--           settings = {
--             rootMarkers = { ".eslintrc.js", ".eslintrc.json", "package.json" },
--             languages = {
--               javascript = { { formatCommand = "prettier --no-semi --write", formatStdin = true } },
--               javascriptreact = { { formatCommand = "prettier --no-semi --write", formatStdin = true } },
--               jsx = { { formatCommand = "prettier --no-semi --write", formatStdin = true } },
--             },
--           },
--         },
--         elixirls = {
--           filetypes = { "elixir" },
--           settings = {
--             elixirLS = {
--               dialyzerEnabled = true,
--               fetchDeps = true,
--               suggestSpecs = true,
--             },
--           },
--         },
--         html = {
--           filetypes = { "html", "htmldjango" }, -- Add "django-html" as a recognized filetype
--           settings = {
--             html = {
--               suggest = {
--                 completionItem = {
--                   triggerCharacters = { "{{" }, -- Example: trigger completion on "{{" in Django templates
--                 },
--               },
--             },
--           },
--         },
--         pylsp = {
--           filetypes = { "python" },
--           settings = {
--             pylsp = {
--               plugins = {
--                 mccabe = { enabled = true, threshold = 20 },
--                 black = { enabled = false },
--                 autopep8 = { enabled = false },
--                 yapf = { enabled = false },
--                 pylint = { enabled = false, executable = "pylint" },
--                 pyflakes = { enabled = false },
--                 pycodestyle = { enabled = true, ignore = { "E501", "W503" } },
--                 flake8 = { enabled = true, ignore = { "E501", "W503" } },
--               },
--             },
--           },
--         },
--         lua_ls = {
--           filetypes = { "lua" },
--           settings = {
--             Lua = {
--               workspace = { checkThirdParty = false },
--               telemetry = { enable = false },
--               diagnostics = { disable = { "missing-fields" } },
--             },
--           },
--         },
--       }
--
--       local on_attach = function(client, bufnr)
--         local nmap = function(keys, func, desc)
--           if desc then
--             desc = "LSP: " .. desc
--           end
--
--           vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
--         end
--
--         nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
--         nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
--
--         nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
--         nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
--         nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
--         nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
--         nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
--         nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
--         nmap("<leader>f", function()
--           conform.format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
--         end, "[F]ormat")
--         nmap("K", vim.lsp.buf.hover, "Hover Documentation")
--
--         -- Lesser used LSP functionality
--         nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
--         nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
--         nmap("<leader>wl", function()
--           print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--         end, "[W]orkspace [L]ist Folders")
--
--         client.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--           virtual_text = true,
--           underline = true, -- You can adjust the diagnostic display here
--           signs = true,
--           update_in_insert = false,
--         })
--       end
--
--       local capabilities = vim.lsp.protocol.make_client_capabilities()
--       capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
--
--       local mason_lspconfig = require("mason-lspconfig")
--
--       mason_lspconfig.setup({
--         ensure_installed = vim.tbl_keys(servers),
--       })
--
--       mason_lspconfig.setup_handlers({
--         function(server_name)
--           require("lspconfig")[server_name].setup({
--             capabilities = capabilities,
--             on_attach = on_attach,
--             settings = servers[server_name] and servers[server_name].settings or {},
--             filetypes = servers[server_name] and servers[server_name].filetypes or nil,
--           })
--         end,
--       })
--     end,
--   },
-- }
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
