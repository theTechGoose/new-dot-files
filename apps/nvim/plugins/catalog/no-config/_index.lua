local Plugin = require("utils.plugin-template")

local _plenary = Plugin:new("nvim-lua/plenary.nvim")
local _volt = Plugin:new("nvzone/volt")
local _menu = Plugin:new( "nvzone/menu")

local plenary = _plenary:serialize()
local volt =    _volt:serialize()
local menu =    _menu:serialize() 

return {
    plenary = plenary,
    volt = volt,
    menu = menu
}
