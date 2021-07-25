return function(client)
  local ts_utils = require("nvim-lsp-ts-utils")

  ts_utils.setup {
    debug = false,
    disable_commands = false,
    enable_import_on_completion = false,

    import_all_timeout = 5000,
    import_all_priorities = {
      buffers = 4,
      buffer_content = 3,
      local_files = 2,
      same_file = 1
    },
    import_all_scan_buffers = 100,
    import_all_select_source = false,

    -- eslint
    eslint_enable_code_actions = true,
    eslint_enable_disable_comments = false,
    eslint_bin = "eslint_d",
    eslint_config_fallback = nil,
    eslint_enable_diagnostics = false,

    -- formatting
    enable_formatting = false,
    formatter = "prettierd",
    formatter_config_fallback = nil,

    -- update imports on file move
    update_imports_on_move = false,
    require_confirmation_on_move = false,
    watch_dir = nil
  }

  -- required to enable ESLint code actions and formatting
  ts_utils.setup_client(client)
end
