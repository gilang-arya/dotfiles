return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",  -- atau bisa menggunakan branch atau commit hash
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					layout_strategy = "horizontal",
					layout_config = {
						prompt_position = "top",
						width = 0.75,  -- Lebar pencarian
						height = 0.8,  -- Tinggi pencarian
						preview_cutoff = 120,  -- Menyembunyikan preview jika lebih panjang dari 120 karakter
					},
					sorting_strategy = "ascending",
					file_ignore_patterns = {
						"node_modules", ".git/", "dist", "*.min.js", "*.lock", "*.tar", "*.zip"
					},
				},
			})

			-- Memuat fzf extension jika tersedia
			pcall(telescope.load_extension, "fzf")
		end,
	},
}

