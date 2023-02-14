local M = {}

function M.setup(lsp, options)
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  lsp.lua_ls.setup(vim.tbl_extend("force", options, {
    settings = {
      Lua = {
        diagnostics = {
          enable = true,
          globals = { "vim" },
          neededFileStatus = { ["codestyle-check"] = "Any" },
          workspaceDelay = -1,
        },
        format = {
          enable = false,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            max_line_length = "80",
          },
        },

        runtime = { version = "LuaJIT", path = runtime_path },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
    on_attach = function(client, bufnr)
      options.on_attach(client, bufnr)

      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
    end,
  }))
end

return M
