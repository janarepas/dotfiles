-- Only explicit installation contacts GitHub. Ordinary startup stays offline.
local theme = {
  src = "https://github.com/folke/tokyonight.nvim",
  version = "cdc07ac78467a233fd62c493de29a17e0cf2b2b6",
}

local function load_theme()
  local loaded = pcall(vim.cmd.packadd, "tokyonight.nvim")
  if not loaded then
    return false
  end
  local ok, tokyonight = pcall(require, "tokyonight")
  if not ok then
    return false
  end
  local configured, err = pcall(function()
    tokyonight.setup({
      transparent = true,
      styles = { sidebars = "transparent", floats = "transparent" },
    })
    vim.cmd.colorscheme("tokyonight-night")
  end)
  if not configured then
    pcall(vim.cmd.colorscheme, "default")
    vim.notify("TokyoNight could not load: " .. tostring(err), vim.log.levels.WARN)
  end
  return configured
end

vim.api.nvim_create_user_command("DotfilesInstallPlugins", function()
  if not (vim.pack and vim.pack.add) then
    vim.notify("Plugin installation requires Neovim 0.12+.", vim.log.levels.ERROR)
    return
  end
  if vim.fn.executable("git") ~= 1 then
    vim.notify("Install Git before installing plugins.", vim.log.levels.ERROR)
    return
  end
  local ok, err = pcall(vim.pack.add, { theme })
  if not ok then
    vim.notify("Plugin installation failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  if not load_theme() then
    vim.notify("Theme unavailable; restart Neovim after installation.", vim.log.levels.WARN)
  end
end, { desc = "Install the pinned TokyoNight theme (requires network)" })

load_theme()
