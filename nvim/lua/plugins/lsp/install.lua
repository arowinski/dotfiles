local util = require("util")

local M = {}

function M.ensure(servers)
  local lsp_servers = require("nvim-lsp-installer.servers")

  for _, server in ipairs(servers) do
    local ok, s = lsp_servers.get_server(server)

    if ok then
      if not s:is_installed() then
        util.info("Installing " .. server .. " LSP")
        s:install()
      end
    else
      util.error("Server " .. server .. " not found")
    end
  end
end

function M.setup(servers, options)
  local lsp_installer = require("nvim-lsp-installer")

  lsp_installer.on_server_ready(function(server)
    local config = servers[server.name] or {}

    -- Skip when defined root directory not found
    if not config.root_dir or config.root_dir(vim.fn.getcwd()) then
      server:setup(vim.tbl_deep_extend("force", options, config))

      vim.cmd([[ do User LspAttachBuffers ]])
    end
  end)
end

return M
