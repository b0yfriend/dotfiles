local status_ok, _return_val = pcall(require, 'lspconfig')
if not status_ok then
	return
end

require('lsp_setup/handlers').setup()

local servers = { 'clangd', 'tsserver', 'sumneko_lua' }
for _idx, server_name in pairs(servers) do
	require('lspconfig')[server_name].setup {
		on_attach = require('lsp_setup/handlers').on_attach,
		flags = {
			-- This will be the default in neovim 0.7+
			debounce_text_changes = 150,
		}
	}
end
