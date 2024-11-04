return {
  "mfussenegger/nvim-dap",
  lazy = true,
  "nvim-telescope/telescope-dap.nvim",
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "nvim-dap-virtual-text",
    "nvim-dap-ui",
  },
  wkeys = {
    {
      d = {
        name = "+debug",
        c = { '<Cmd>lua require"dap".continue()<CR>', "continue" },
        l = { '<Cmd>lua require"dap".run_last()<CR>', "run last" },
        q = { '<Cmd>lua require"dap".terminate()<CR>', "terminate" },
        h = { '<Cmd>lua require"dap".stop()<CR>', "stop" },
        n = { '<Cmd>lua require"dap".step_over()<CR>', "step over" },
        s = { '<Cmd>lua require"dap".step_into()<CR>', "step into" },
        S = { '<Cmd>lua require"dap".step_out()<CR>', "step out" },
        b = { '<Cmd>lua require"dap".toggle_breakpoint()<CR>', "toggle br" },
        B = { '<Cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', "set br condition" },
        p = { '<Cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', "set log br" },
        r = { '<Cmd>lua require"dap".repl.open()<CR>', "REPL open" },
        k = { '<Cmd>lua require"dap".up()<CR>', "up callstack" },
        j = { '<Cmd>lua require"dap".down()<CR>', "down callstack" },
        i = { '<Cmd>lua require"dap.ui.widgets".hover()<CR>', "info" },
        ["?"] = {
          '<Cmd>lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>',
          "scopes",
        },
        -- f = { "<Cmd>Telescope dap frames<CR>", "search frames" },
        -- C = { "<Cmd>Telescope dap commands<CR>", "search commands" },
        -- L = { "<Cmd>Telescope dap list_breakpoints<CR>", "search breakpoints" },
      },
    },
    { prefix = "<leader>" },
  },
  config = function()
    local dap = require("dap")
    vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "🚏", texthl = "", linehl = "", numhl = "" })
    dap.defaults.fallback.terminal_win_cmd = "tabnew"
    dap.defaults.fallback.focus_terminal = true

    local dap_python = require("dap-python")
    dap_python.setup(os.getenv("MY_PYTHON_PATH"))
    dap_python.test_runner = "pytest"
    dap_python.default_port = 5678

    dap.listeners.after.event_initialized["dapui_config"] = function()
      require("dapui").open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      require("dapui").close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      require("dapui").close()
    end
  end,
}
