local map = vim.keymap.set
local LspServer = {}
LspServer.__index = LspServer

local is_setup = false
function global_setup()
	if is_setup then return end
dofile(vim.g.base46_cache .. "lsp")
require("nvchad.lsp").diagnostic_config()
end

function _compile_fn(ref, type)
    local target = ref and ref[type] and not vim.tbl_isempty(ref[type]) or LspServer.defaults[type]
    if not target or vim.tbl_isempty(target) then
        error("LSP compile function failed: target could not be resolved")
        return function() end
    end
    return function(client, bufnr)
        local function opts(desc)
            return { buffer = bufnr, desc = "LSP " .. desc }
        end
        for _, fn in ipairs(target) do
            pcall(fn, client, bufnr, opts)
        end
    end
end

local lsp_config = nil
local function _get_lsp_config() 
	if lsp_config then return lsp_config end
	lsp_config = require("lspconfig")
	return lsp_config
end


function LspServer:new(name, _capabilities) 
  local capabilities = _capabilities and _capabilities or LspServer.defaults.capabilities_factory()
  local instance = setmetatable({}, LspServer)
  instance.events = {}
  instance.events.attach = {}
  instance.events.init = {}
  instance.capabilities = capabilities
  instance.name = name
  global_setup()
  return instance
end


function LspServer:configure(opts) 
	local lsp = _get_lsp_config()

if not lsp[self.name] then
    error("Invalid LSP server name: " .. self.name)
end

local _payload = {
		on_attach = _compile_fn(self.events, 'attach'),
		on_init = _compile_fn(self.events, 'init'),
		capabilities = self.capabilities
 }

 local payload = vim.tbl_deep_extend("force", _payload, opts or {})

	lsp[self.name].setup(payload)
 return self
end

function LspServer:add(event, fn)
    if not (event == "init" or event == "attach") then
        error('Invalid event type: must be "init" or "attach".')
    end
    if type(fn) ~= "function" then
        error("Event handler must be a function.")
    end
    table.insert(self.events[event], fn)
    return self
end


local tmp = vim.lsp.protocol.make_client_capabilities()
tmp.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

LspServer.defaults = {}
LspServer.defaults.capabilities_factory = function(override)
	return vim.tbl_deep_extend("force", tmp, override or {})
end



LspServer.defaults.events = {}
LspServer.defaults.events.init = {
  disable_semantic_tokens = function(client, bufnr, opts) 
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
  end
}

LspServer.defaults.mappings = {
	go_to_declaration = function(_, bufnr, opts) 
          map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
	end,
	go_to_definition = function(_, bufnr, opts)
          map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
	end,
go_to_implementation = function(_, bufnr, opts) 
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
end,
show_signature_help = function(_, bufnr, opts) 
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
end,
add_workspace_folder = function(_, bufnr, opts)
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
end,
remove_workspace_folder = function(_, bufnr, opts)
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
end,
list_workspace_folders = function(_, bufnr, opts)
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")
end,
go_to_type_definition = function(_, bufnr, opts)
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
end,
nv_renamer = function(_, bufnr, opts) 
  map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")
end,
code_action = function(_, bufnr, opts)
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
end,
show_references = function(_, bufnr, opts)
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end




}


LspServer.defaults.init = LspServer.defaults.events.init
LspServer.defaults.attach = LspServer.defaults.mappings

return LspServer



