local Plugin = require("utils.plugin-template")
local luasnip = require("plugins.catalog.cmp.luasnip")
local autopairs = require("plugins.catalog.cmp.autopairs")
local plugin = Plugin:new("hrsh7th/nvim-cmp")
--plugin:load_on_event("InsertEnter")

-- Deps
plugin:dep(luasnip)
plugin:dep(autopairs)
plugin:dep(Plugin:new("saadparwaiz1/cmp_luasnip"))
plugin:dep(Plugin:new("hrsh7th/cmp-nvim-lua"))
plugin:dep(Plugin:new("hrsh7th/cmp-nvim-lsp"))
plugin:dep(Plugin:new("hrsh7th/cmp-buffer"))
plugin:dep(Plugin:new("hrsh7th/cmp-path"))


-- Opts
plugin:opts_as_fn(function(_, opts)
  local cmp = require "cmp"
  local payload = {
    completion = { completeopt = "menu,menuone" },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
    },
  }

  return payload
end)

-- Mappings
plugin:map('i', "<C-p>", function()
  require("cmp").mapping.select_prev_item()
end)

-- Helper function to feed keys
local function feedkey(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', true)
end

-- <C-p>
plugin:map('i', '<C-p>', function()
  require('cmp').select_prev_item()
end)

-- <C-n>
plugin:map('i', '<C-n>', function()
  require('cmp').select_next_item()
end)

-- <C-d>
plugin:map('i', '<C-d>', function()
  require('cmp').scroll_docs(-4)
end)

-- <C-f>
plugin:map('i', '<C-f>', function()
  require('cmp').scroll_docs(4)
end)

-- <C-Space>
plugin:map('i', '<C-Space>', function()
  require('cmp').complete()
end)

-- <C-e>
plugin:map('i', '<C-e>', function()
  require('cmp').close()
end)

-- <CR>
plugin:map('i', '<CR>', function()
  require('cmp').confirm({
    behavior = require('cmp').ConfirmBehavior.Insert,
    select = true,
  })
end)

-- <Tab>
local function tab_complete()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    feedkey('<Tab>')
  end
end

plugin:map({ 'i', 's' }, '<Tab>', tab_complete)

-- <S-Tab>
local function s_tab_complete()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    feedkey('<S-Tab>')
  end
end

plugin:map({ 'i', 's' }, '<S-Tab>', s_tab_complete)

return plugin:serialize()
