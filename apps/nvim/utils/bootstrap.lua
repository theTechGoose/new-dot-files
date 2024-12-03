-- Add your Neovim configuration directory to Lua's package path
local config_path = vim.fn.stdpath('config') .. '/'

-- Ensure the config path is part of the Lua package search path
package.path = package.path .. ';' .. config_path .. '?.lua' .. ';' .. config_path .. '?/init.lua'

