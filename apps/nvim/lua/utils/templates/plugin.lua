local Plugin = {}
Plugin.__index = Plugin
Plugin.__class = 'Plugin'

local function defineIfUndefined(obj, prop)
    if not obj[prop] then obj[prop] = {} end
end

local function hasMoreThanOneKey(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
        if count > 1 then
            return true
        end
    end
    return false
end

function Plugin:new(name)
	local instance = setmetatable({}, Plugin)
  instance[1] = name
	return instance
end

function Plugin:add_cmd(name)
  defineIfUndefined(self, 'cmd')
  table.insert(self.cmd, name)
end

function Plugin:add_key(mode, lhs, rhs)
  defineIfUndefined(self, 'keys')
  table.insert({mode, lhs, rhs})
end

function Plugin:add_dep(dep)
  if dep.__class ~= 'Plugin' and type(dep) ~= 'string' then
    print(vim.inspect(dep))
    error('Type of dependecy incompatible with add_dep for plugin' .. self.name)
  end
end

function Plugin:serialize()
  setmetatable(self, nil)
  if not hasMoreThanOneKey(self) then self = self[1] end
  return self
end





local p = Plugin:new('dooks')
print(vim.inspect(p:serialize()))
