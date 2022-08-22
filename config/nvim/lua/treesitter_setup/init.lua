local status_ok, return_val = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
	return
end

local configs = return_val
configs.setup {
	sync_install = false,
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = false },
}

status_ok, return_val = pcall(require, 'nvim-treesitter.install')
if not status_ok then
	return
end

-- the README.md is pretty insistent on updating treesitter
-- (typically via ":TSUpdate") whenever you update treesitter
-- itself. I'm just doing it here every time for simplicity
local installer_module = return_val
installer_module.update()

vim.filetype.add({
	filename = {
		["Containerfile"] = "dockerfile",
	}
})
