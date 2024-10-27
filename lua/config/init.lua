require("config.options")
require("config.lazy")
require("config.remaps")
local dap = require("dap")

dap.adapters.python = {
  type = "server",
  host = "127.0.0.1",
  port = 5678, -- Updated to connect to internal debugpy socket
}

dap.configurations.python = {
  {
    type = "python",
    request = "attach",
    name = "Attach to Docker - Python",
    connect = {
      host = "127.0.0.1",
      port = 5678,
    },
    pathMappings = {
      {
        localRoot = vim.fn.getcwd(),
        remoteRoot = "/code",
      },
    },
  },
}
