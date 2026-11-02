
-- Web development: HTML, CSS, JavaScript, JSON
-- Neovim 0.12+ built-in LSP, no additional plugins.

local servers = {
  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
  },
  css = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
  },
  json = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
  },
}

for name, config in pairs(servers) do
  config.root_markers = { "package.json", ".git" }
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

-- Useful LSP shortcuts.
vim.keymap.set("n", "gd", vim.lsp.buf.definition,
  { desc = "Go to definition" })

vim.keymap.set("n", "K", vim.lsp.buf.hover,
  { desc = "Show documentation" })

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
  { desc = "Rename symbol" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
  { desc = "Code actions" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
  { desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
  { desc = "Next diagnostic" })

-- Manual Prettier formatting, never automatic on save.
vim.api.nvim_create_user_command("Prettier", function()
  local filename = vim.api.nvim_buf_get_name(0)

  if filename == "" then
    vim.notify("Save the file first.", vim.log.levels.WARN)
    return
  end

  if vim.fn.executable("prettier") ~= 1 then
    vim.notify("Prettier is not installed.", vim.log.levels.ERROR)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local input = table.concat(lines, "\n") .. "\n"

  local result = vim.system({
    "prettier",
    "--stdin-filepath",
    filename,
  }, {
    stdin = input,
    text = true,
  }):wait()

  if result.code ~= 0 then
    vim.notify(result.stderr or "Prettier failed.",
      vim.log.levels.ERROR)
    return
  end

  local output = vim.split(result.stdout, "\n", { plain = true })

  if output[#output] == "" then
    table.remove(output)
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
  vim.notify("Formatted with Prettier.")
end, { desc = "Format current file with Prettier" })

vim.keymap.set("n", "<leader>f", "<cmd>Prettier<cr>",
  { desc = "Format with Prettier" })

-- Automatic LSP completion
vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("WebDevCompletion", {
    clear = true,
  }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = true,
      })
    end
  end,
})
