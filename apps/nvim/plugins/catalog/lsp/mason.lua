local Plugin = require("utils.plugin-template")
local mason = Plugin:new("williamboman/mason.nvim")
mason:toggle_lazy()

mason:opts_as_fn(function() 
dofile(vim.g.base46_cache .. "mason")
return {
  PATH = "skip",
  ui = {
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ",
    },
  },
  max_concurrent_installers = 10,
}
end)

mason:cfg(function(_, opts) 
	require('mason').setup(opts)
end)

return mason:serialize()
