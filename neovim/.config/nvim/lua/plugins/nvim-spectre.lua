return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("spectre").setup({
			color_devicons = true,  -- Menampilkan ikon berdasarkan jenis file
			mapping = {
				["toggle_line"] = "<cr>",  -- Menandai baris untuk penggantian
				["enter_file"] = "o",     -- Masuk ke file untuk penggantian
				["select_next_item"] = "<tab>",  -- Pindah ke item berikutnya
				["select_prev_item"] = "<s-tab>", -- Pindah ke item sebelumnya
				["swap_next"] = "gn",     -- Tukar posisi dengan item berikutnya
				["swap_prev"] = "gN",     -- Tukar posisi dengan item sebelumnya
				["send_to_qf"] = "<leader>qf",  -- Kirim hasil ke quickfix
				["run_current_replace"] = "<leader>rc", -- Jalankan penggantian saat ini
			},
			search_engine = "ag",  -- Gunakan Silver Searcher (ag) sebagai mesin pencarian (bisa ganti dengan 'rg' atau 'grep')
		})
	end,
}


