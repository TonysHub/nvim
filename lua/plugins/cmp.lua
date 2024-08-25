return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = nil,
          ["<S-Tab>"] = nil,
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },
}
-- return {
--   {
--     "hrsh7th/nvim-cmp",
--     dependencies = {
--       "L3MON4D3/LuaSnip",
--       "saadparwaiz1/cmp_luasnip",
--       "hrsh7th/cmp-nvim-lsp",
--       "hrsh7th/cmp-path",
--       "github/copilot.vim",
--     },
--     config = function()
--       local cmp = require("cmp")
--       local luasnip = require("luasnip")
--       require("luasnip.loaders.from_vscode").lazy_load()
--       luasnip.config.setup({})
--
--       cmp.setup({
--         snippet = {
--           expand = function(args)
--             luasnip.lsp_expand(args.body)
--           end,
--         },
--         completion = {
--           completeopt = "menu,menuone,noinsert",
--         },
--         mapping = cmp.mapping.preset.insert({
--           ["<C-j>"] = cmp.mapping.select_next_item(),
--           ["<C-k>"] = cmp.mapping.select_prev_item(),
--           ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--           ["<C-f>"] = cmp.mapping.scroll_docs(4),
--           ["<C-Space>"] = cmp.mapping.complete({}),
--           ["<C-y>"] = cmp.mapping.confirm({
--             behavior = cmp.ConfirmBehavior.Replace,
--             select = true,
--           }),
--           ["<Tab>"] = cmp.mapping(function(fallback)
--             if vim.fn["copilot#Accept"]() ~= "" then
--               -- Accept Copilot suggestion if available
--               vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
--             else
--               fallback() -- If no Copilot suggestion, fallback to next mapping (which could be select_next_item)
--             end
--           end, { "i", "s" }),
--           ["<S-Tab>"] = nil, -- Remove Shift-Tab if not needed
--         }),
--         sources = {
--           { name = "nvim_lsp" },
--           { name = "luasnip" },
--           { name = "path" },
--           { name = "copilot" }, -- Include Copilot as a source
--         },
--       })
--     end,
--   },
-- }
