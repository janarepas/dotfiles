-- Filename-based protection for common credential files, before reading undo.
-- This deliberately keeps protection after renaming a sensitive buffer.
local patterns = {
  "*/.env", "*/.env.*", "*.pem", "*.key", "*.p12", "*.pfx",
  "*/id_rsa", "*/id_ecdsa", "*/id_ed25519", "*/id_dsa",
  "*/.ssh/*", "*/.gnupg/*", "*/.netrc", "*/.authinfo", "*/.authinfo.gpg",
  "*/.aws/credentials", "*/.kube/config", "*/.docker/config.json",
  "*/.npmrc", "*/.pypirc", "*/.git-credentials",
}

-- 'backupskip' also covers temporary write-backups, separately from swap/undo.
vim.opt.backupskip:append(patterns)
local regexes = vim.tbl_map(function(pattern)
  return vim.regex(vim.fn.glob2regpat(pattern))
end, patterns)

local group = vim.api.nvim_create_augroup("DotfilesPrivacy", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "BufFilePost", "BufWritePre" }, {
  group = group,
  pattern = "*",
  callback = function(event)
    local name = vim.api.nvim_buf_get_name(event.buf)
    if name == "" then return end
    local resolved = vim.fn.resolve(name)
    for _, regex in ipairs(regexes) do
      if regex:match_str(name) or regex:match_str(resolved) then
        if vim.b[event.buf].dotfiles_private_name ~= name then
          vim.opt.backupskip:append({ vim.fn.escape(name, "*?[\\]") })
          vim.b[event.buf].dotfiles_private_name = name
        end
        vim.bo[event.buf].swapfile = false
        vim.bo[event.buf].undofile = false
        vim.bo[event.buf].modeline = false
        return
      end
    end
  end,
  desc = "Disable disk recovery files and modelines for credential paths",
})
