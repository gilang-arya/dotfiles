return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	event = "InsertEnter",
	config = function()
		require("codeium").setup({
			virtual_text = {
				enabled = true,
				idle_delay = 100,
			},
			enable_cmp_source = true,
		})
	end,
}
