local Plugin = require("utils.plugin-template")
local minty = Plugin:new("nvzone/minty")
minty:cmd("Huefy")
minty:cmd("Shades")
return minty:serialize()

