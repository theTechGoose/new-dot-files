local Plugin = {}
Plugin.__index = Plugin

-- Constructor
function Plugin:new(pluginName, opts)
  opts = opts or {}
  local instance = {
    plugin = pluginName,
    type = opts.type or "remote",
    config = function() end,
    dependencies = {},
    opts = {},
    keys = {},
    command = {},
    lazy = nil,
    event = nil,
    build = nil
  }
  if instance.type == "local" then
    instance.plugin = { dir = vim.fn.expand(pluginName:match("^~") and pluginName or "~/projects/" .. pluginName) }
  end
  setmetatable(instance, Plugin)
  return instance
end

-- Set load conditions (event, filetype, etc.)
function Plugin:load_on_event(identifier)
	self.event= identifier
end

-- Mark the plugin as local
function Plugin:set_as_local()
  self.plugin = { dir = vim.fn.expand(self.plugin) }
  return self
end

function Plugin.exec(name)
	pcall(function()
dofile(vim.g.base46_cache .. name)
	end)
return self
end

-- Add a dependency
function Plugin:dep(dep)
  if getmetatable(dep) == Plugin then
    table.insert(self.dependencies, dep)
  else
    error("Dependency must be a Plugin instance")
  end
  return self
end

function Plugin:cmd(cmd)
	table.insert(self.command, cmd)
end

function Plugin:bld(fn)
	self.build = fn
end

function Plugin:toggle_lazy()
	if self.lazy == nil then
		self.lazy = false
		return self
	end
	self.lazy = not self.lazy
	return self
end

function Plugin:opts_as_fn(fn)
	self.opts = fn
end

-- Add an option with support for dot notation keys
function Plugin:opt(key, value)
  -- Initialize self.opts if necessary
  if type(self.opts) ~= "table" then
    self.opts = {}
  end

  -- Validate key
  if type(key) ~= "string" or key == "" then
    error("Key must be a non-empty string")
  end

  local t = self.opts
  local keys = {}

  -- Split the key by dots, ignoring empty segments
  for k in string.gmatch(key, "[^%.]+") do
    if k ~= "" then
      table.insert(keys, k)
    else
      error("Invalid key segment: empty string")
    end
  end

  -- Traverse or create nested tables
  for i = 1, #keys - 1 do
    local k = keys[i]

    -- Check if the existing value is a table
    if t[k] ~= nil and type(t[k]) ~= "table" then
      error(string.format("Cannot index non-table value at '%s'", table.concat(keys, ".", 1, i)))
    end

    t[k] = t[k] or {}
    t = t[k]
  end

  local finalKey = keys[#keys]

  -- Optional: Check if finalKey already exists
  if t[finalKey] ~= nil then
    -- Decide whether to overwrite or raise an error
    -- For this example, we'll overwrite and issue a warning
    print(string.format("Warning: Overwriting existing value at '%s'", key))
  end

  -- Set the final value
  t[finalKey] = value

  return self
end

-- Map a key
function Plugin:map(mode, lhs, rhs, filetype)
  table.insert(self.keys, {lhs, rhs, mode=mode})
  return self
end

-- Set config function
function Plugin:cfg(fn)
  self.config = fn
  return self
end

-- Serialize dependencies recursively
function Plugin:_serialize_dependencies()
  local serialized_dependencies = {}
  for _, dep in ipairs(self.dependencies) do
    table.insert(serialized_dependencies, dep:serialize())
  end
  return serialized_dependencies
end

-- Serialize the plugin configuration for LazyNvim
function Plugin:serialize()
local opts_not_fn = type(self.opts) ~= "function"
local opts = self.opts
if(opts_not_fn) then opts = next(self.opts) and self.opts or nil end


	local serialized = {
    self.plugin,
    dependencies = #self.dependencies > 0 and self:_serialize_dependencies() or nil,
    opts = opts,
    keys = #self.keys > 0 and self.keys or nil,
    cmd = #self.command > 0 and self.command or nil,
    build = self.build and self.build or nil,
    lazy = self.lazy == nil,
    event = self.event ~= nil and self.event or nil,
    config = self.config and self.config or nil
  }
  if self.lazy ~= nil then
	  serialized.lazy = self.lazy
  end
  return serialized
end

return Plugin
