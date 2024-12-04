local Plugin = require('utils.plugin-template')
local conform = Plugin:new('stevearc/conform.nvim')
conform:opt('formatters_by_ft.lua', {"stylua"})
return conform:serialize()
