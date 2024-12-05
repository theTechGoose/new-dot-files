local Plugin = require("utils.plugin-template")
local lspconfig = Plugin:new("neovim/nvim-lspconfig")
lspconfig:cfg(function()
  require("lsp._init")
end)
lspconfig:toggle_lazy()

return lspconfig:serialize()
