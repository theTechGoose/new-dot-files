local Plugin = {}
Plugin.__index = Plugin

-- Constructor
function Plugin:new(pluginName, opts)
  opts = opts or {}
  local instance = {
    plugin = pluginName,
    type = opts.type or "remote",
    config = {},
    dependencies = {},
    opts = {},
    keys = {},
  }
  if instance.type == "local" then
    instance.plugin = { dir = vim.fn.expand(pluginName:match("^~") and pluginName or "~/projects/" .. pluginName) }
  end
  setmetatable(instance, Plugin)
  return instance
end

-- Set load conditions (event, filetype, etc.)
function Plugin:load_on(condition, ...)
  local args = { ... }
  if condition == "event" then
    self.config.event = #args == 1 and args[1] or args
  elseif condition == "ft" then
    self.config.ft = #args == 1 and args[1] or args
  else
    error("Unsupported load condition: " .. condition)
  end
  return self
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

-- Add an option
function Plugin:opt(key, value)
  self.opts[key] = value
  return self
end

-- Map a key
function Plugin:map(mode, lhs, rhs, filetype)
  table.insert(self.keys, { mode = mode, lhs = lhs, rhs = rhs, ft = filetype })
  return self
end

-- Set config function
function Plugin:cfg(fn)
  self.config.config = fn
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
  local serialized = vim.tbl_deep_extend("force", {
    self.plugin,
    dependencies = #self.dependencies > 0 and self:_serialize_dependencies() or nil,
    opts = next(self.opts) and self.opts or nil,
    keys = #self.keys > 0 and self.keys or nil,
  }, self.config)
  return serialized
end

return Plugin
