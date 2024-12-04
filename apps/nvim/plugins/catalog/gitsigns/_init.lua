local Plugin = require("utils.plugin-template")
local gitsigns = Plugin:new("lewis6991/gitsigns.nvim")
gitsigns:load_on_event("User FilePost")
gitsigns:opts_as_fn(function() 
dofile(vim.g.base46_cache .. "git")

return {
  signs = {
    delete = { text = "󰍵" },
    changedelete = { text = "󱕖" },
  },
}
end)
return gitsigns:serialize()
