local Plugin = require("utils.plugin-template")
local plugin = Plugin:new("L3MON4D3/LuaSnip")
plugin:opt('history', true)
plugin:opt('updateevents', "TextChanged,TextChangedI")
plugin:dep(Plugin:new('rafamadriz/friendly-snippets'))

local function setup(opts)
require("luasnip").config.set_config(opts)
	local formats = {"vscode", "snipmate", "lua"}

local function getLoader(name) 
   local loader = require("luasnip.loaders.from_" .. name)
   local base_path = vim.g[name .. "_snippets_path"] or ""
   local payload = {paths = base_path}
   if name == 'vscode' then payload.exclude = vim.g.vscode_snippets_exclude or {} end
   return loader, payload
end

for _, format in ipairs(formats) do
   local loader, payload = getLoader(format)
   loader.lazy_load(payload)
   if format ~= "vscode" then
      loader.load()
   end
end

-- Autocommand to unlink current snippet on InsertLeave
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    local luasnip = require("luasnip")
    if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
      luasnip.unlink_current()
    end
  end,
})

end

plugin:cfg(setup)


return plugin
