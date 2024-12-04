local Plugin = require("utils.plugin-template")
local dev_icons = Plugin:new("nvim-tree/nvim-web-devicons")
dev_icons:opts_as_fn(function() 
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
end)

local tree = Plugin:new("nvim-tree/nvim-tree.lua")
tree:cmd("NvimTreeToggle")
tree:cmd("NvimTreeFocus")
tree:dep(dev_icons)

tree:map("n", "<C-n>", function() 
local api = require "nvim-tree.api"
api.tree.toggle()
end)

tree:opts_as_fn(function() 
  dofile(vim.g.base46_cache .. "nvimtree")
  return {
  filters = { dotfiles = false },
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    width = 30,
    preserve_window_proportions = true,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        default = "󰈚",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
        },
        git = { unmerged = "" },
      },
    },
  },
}
end)

tree:cfg(function(_, opts) 
	require("nvim-tree").setup(opts)
end)

return tree:serialize()
