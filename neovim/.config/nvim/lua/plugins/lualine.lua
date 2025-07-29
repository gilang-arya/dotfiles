return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Setup Lualine
		require("lualine").setup({
			options = {
				icons_enabled = true, -- Mengaktifkan ikon
				theme = "tokyonight", -- Sesuaikan dengan tema yang digunakan
				component_separators = { left = "", right = "" }, -- Pisahkan komponen dengan ikon
				section_separators = { left = "", right = "" }, -- Pisahkan bagian dengan ikon
				disabled_filetypes = { "NvimTree", "packer" }, -- Nonaktifkan statusline pada file ini
			},
			sections = {
				lualine_a = { "mode" }, -- Menampilkan mode (misal: normal, insert)
				lualine_b = { "branch", "diff", "diagnostics" }, -- Branch Git, Diff, Diagnostics
				lualine_c = { "filename" }, -- Nama file
				lualine_x = { "encoding", "fileformat", "filetype" }, -- Menampilkan encoding, format file, tipe file
				lualine_y = { "progress" }, -- Menampilkan progress bar
				lualine_z = { "location" }, -- Menampilkan lokasi baris dan kolom
			},
			inactive_sections = {
				lualine_a = { "filename" }, -- Nama file saat buffer tidak aktif
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive", "nvim-tree" }, -- Menambahkan ekstensi seperti Git atau NvimTree
		})
	end,
}
