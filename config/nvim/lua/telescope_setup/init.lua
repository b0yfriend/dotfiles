local status_ok, return_val = pcall(require, "telescope")
if not status_ok then
  return
end

local telescope = return_val
telescope.setup({
	defaults = {
		path_display = { "truncate" }
	}
})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>Telescope live_grep<CR>', opts)
