return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader><space>", false }, -- Disable the default mapping for <leader><space>
      {
        "<leader>sf",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end,
        desc = "[S]earch [F]ile",
      },
      {
        "<leader>sf",
        function()
          local function getVisualSelection()
            vim.cmd('noau normal! "vy"')
            local text = vim.fn.getreg("v")
            vim.fn.setreg("v", {})

            text = string.gsub(text, "\n", "")
            if #text > 0 then
              return text
            else
              return ""
            end
          end

          local text = getVisualSelection()
          require("telescope.builtin").live_grep({ default_text = text })
        end,
        mode = "v",
        desc = "[S]earch [F]ile",
      },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end

      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
      end

      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        LazyVim.pick("find_files", { hidden = true, default_text = line })()
      end

      local function find_command()
        if vim.fn.executable("rg") == 1 then
          return { "rg", "--files", "--color", "never", "-g", "!.git" }
        elseif vim.fn.executable("fd") == 1 then
          return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
        elseif vim.fn.executable("fdfind") == 1 then
          return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
        elseif vim.fn.executable("find") == 1 and vim.fn.has("win32") == 0 then
          return { "find", ".", "-type", "f" }
        elseif vim.fn.executable("where") == 1 then
          return { "where", "/r", ".", "*" }
        end
      end

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        prompt_prefix = " ",
        selection_caret = " ",
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
        mappings = {
          i = {
            ["<c-t>"] = open_with_trouble,
            ["<a-t>"] = open_with_trouble,
            ["<a-i>"] = find_files_no_ignore,
            ["<a-h>"] = find_files_with_hidden,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
          },
          n = {
            ["q"] = actions.close,
          },
        },
        layout_config = {
          width = 0.85,
          preview_cutoff = 120,
          horizontal = {
            preview_width = function(_, cols, _)
              if cols < 120 then
                return math.floor(cols * 0.5)
              end
              return math.floor(cols * 0.6)
            end,
            mirror = false,
          },
          vertical = { mirror = false },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
        file_ignore_patterns = {
          "node_modules/",
          "%.git/",
          "%.DS_Store$",
          "target/",
          "build/",
          "%.o$",
        },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" },
      })

      opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
        find_files = { find_command = find_command, hidden = true },
        live_grep = {
          only_sort_text = true,
        },
      })

      return opts
    end,
  },
}
