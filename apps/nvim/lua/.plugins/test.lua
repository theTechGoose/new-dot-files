return {
		"vim-test/vim-test",
		dependencies = {
					"tpope/vim-dispatch"
		},
		keys = {
			{"<leader>tn", "<CMD>TestNearest<CR>"}
		},
		config = function()
			vim.g['test#strategy'] = 'dispatch'
			vim.g['test#javascript#runner'] = 'denotest'
		end
	}
