return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()

    local servers = {
      -- ts_ls = {
      --   settings = {
      --     formatting = true,
      --     formatoptions = {
      --       tabSize = 2,
      --       useTabs = false,
      --     },
      --   },
      -- },
      --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
      --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
      -- tsserver = {
      --   enabled = false,
      -- },
      -- ts_ls = {
      --   enabled = false,
      -- },
      vtsls = {
        -- explicitly add default filetypes, so that we can extend
        -- them in related extras
        filetypes = {
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      },
      efm = {
        init_options = { documentFormatting = true },
        filetypes = { "javascript", "javascriptreact", "jsx" },
        settings = {
          rootMarkers = { ".eslintrc.js", ".eslintrc.json", "package.json" },
          languages = {
            javascript = { { formatCommand = "prettier --no-semi --write", formatStdin = true } },
            javascriptreact = { { formatCommand = "prettier --no-semi --write", formatStdin = true } },
            jsx = { { formatCommand = "prettier --no-semi --write", formatStdin = true } },
          },
        },
      },
      gopls = {
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
      },
      elixirls = {
        filetypes = { "elixir" },
        settings = {
          elixirLS = {
            dialyzerEnabled = true,
            fetchDeps = true,
            suggestSpecs = true,
          },
        },
      },
      -- eslint = {
      --   filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      --   settings = {
      --     format = { enable = false },
      --     lint = { enable = true },
      --   },
      -- },
      html = {
        filetypes = { "html", "htmldjango" }, -- Add "django-html" as a recognized filetype
        settings = {
          html = {
            suggest = {
              completionItem = {
                triggerCharacters = { "{{" }, -- Example: trigger completion on "{{" in Django templates
              },
            },
          },
        },
      },
      pylsp = {
        filetypes = { "python" },
        settings = {
          pylsp = {
            plugins = {
              mccabe = { enabled = true, threshold = 20 },
              black = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              pylint = { enabled = false, executable = "pylint" },
              pyflakes = { enabled = false },
              pycodestyle = { enabled = true, ignore = { "E501", "W503" } },
              flake8 = { enabled = true, ignore = { "E501", "W503" } },
            },
          },
        },
      },
      lua_ls = {
        filetypes = { "lua" },
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { disable = { "missing-fields" } },
          },
        },
      },
    }

    local on_attach = function(client, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
      nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
      nmap("gr", function()
        require("fzf-lua").lsp_references({ jump_to_single_result = true, ignore_current_line = true })
      end, "[G]oto [R]eferences")
      nmap("gI", function()
        require("fzf-lua").lsp_implementations()
      end, "[G]oto [I]mplementation")
      nmap("<leader>D", function()
        require("fzf-lua").lsp_typedefs()
      end, "Type [D]efinition")
      nmap("<leader>ds", function()
        require("fzf-lua").lsp_document_symbols()
      end, "[D]ocument [S]ymbols")
      nmap("<leader>ws", function()
        require("fzf-lua").lsp_workspace_symbols()
      end, "[W]orkspace [S]ymbols")
      nmap("<leader>f", function()
        require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
      end, "[F]ormat")
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")

      -- Lesser used LSP functionality
      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
      nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "[W]orkspace [L]ist Folders")

      client.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        underline = true,
        signs = true,
        update_in_insert = false,
      })
      client.server_capabilities.documentHighlightProvider = false
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name] and servers[server_name].settings or {},
          filetypes = servers[server_name] and servers[server_name].filetypes or nil,
        })
      end,
    })
  end,
}
