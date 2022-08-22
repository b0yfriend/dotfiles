local M = {}

M.setup = function()
	local signs = {
		{ hl_group_name = "DiagnosticSignError", text = "▪"},
		{ hl_group_name = "DiagnosticSignWarn", text = "▪"},
		{ hl_group_name = "DiagnosticSignHint", text = "▪"},
		{ hl_group_name = "DiagnosticSignInfo", text = "▪"},
	}
	for _idx, sign in pairs(signs) do
		vim.fn.sign_define(
			sign.hl_group_name,
			{
				text = sign.text,
				texthl = sign.hl_group_name,
				numhl = ""
			}
		)
	end

	local diagnostic_config = {
		virtual_text = false,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		}
	}
	vim.diagnostic.config(diagnostic_config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = "rounded" }
	)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded" }
	)

	local goto_definition_handler = require('lsp_setup/goto_definition_in_split');
	vim.lsp.handlers["textDocument/definition"] = goto_definition_handler('vsplit')
end

local function apply_lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true}
	vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	-- prefer goto_prev() & goto_next() for viewing diagnostics
	-- vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	vim.api.nvim_set_keymap('n', '[l', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions

	-- declaration doesn't seem to be widely supported
	-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '[k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '[rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	--vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '[f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

M.on_attach = function (client, bufnr)
	-- if client.name == "servername (e.g. clangd, tsserver)" then
	--   // whatever you like
	-- end
	apply_lsp_keymaps(bufnr)
end

return M
