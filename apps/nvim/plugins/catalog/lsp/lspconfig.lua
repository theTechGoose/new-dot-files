local Plugin = require("utils.plugin-template")
local lspconfig = Plugin:new("neovim/nvim-lspconfig")
lspconfig:load_on_event("User FilePost")
lspconfig:cfg(function() 
  require("lsp._init")
end)
lspconfig:toggle_lazy()

return lspconfig:serialize()
