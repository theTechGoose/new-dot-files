local Plugin = require("utils.plugin-template")

local base64 = Plugin:new("nvchad/base46")

base64:bld(function()
   require("base46").load_all_highlights()
end)

return base64:serialize()




   
