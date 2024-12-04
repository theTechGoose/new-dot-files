local Plugin = require("utils.plugin-template")
local ui = Plugin:new("nvchad/ui")
ui:cfg(function() require "nvchad" end)
ui:toggle_lazy()
return ui:serialize()

