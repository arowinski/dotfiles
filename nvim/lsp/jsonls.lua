return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git" },
  single_file_support = true,
  init_options = { provideFormatter = true },
  settings = { json = { schemas = require("schemastore").json.schemas() } },
}
