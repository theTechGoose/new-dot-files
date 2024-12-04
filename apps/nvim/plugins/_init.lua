local no_config = require "plugins.catalog.no-config._index"
local lsp = require "plugins.catalog.lsp._init"

local M = {
  no_config.plenary,
  no_config.volt,
  no_config.menu,
  lsp.lspconfig,
  lsp.mason,
  require "plugins.catalog.nvim-tree._init",
  require "plugins.catalog.blankline._init",
  require "plugins.catalog.gitsigns._init",
  require "plugins.catalog.lazygit._init",
  require "plugins.catalog.conform._init",
  require "plugins.catalog.ui.chad-ui",
  require "plugins.catalog.cmp._index",
  require "plugins.catalog.ui.base64",
  require "plugins.catalog.ui.minty",
}

return M
