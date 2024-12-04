local Plugin = require("utils.plugin-template")
local lazygit = Plugin:new("kdheepak/lazygit.nvim")
lazygit:map('n', '<leader>lg', '<CMD>LazyGit<CR>')
return lazygit:serialize()


