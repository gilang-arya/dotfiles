return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- Opsional untuk ikon
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true, -- Menampilkan status git
			enable_diagnostics = true, -- Menampilkan diagnosa
			filesystem = {
				filtered_items = {
					visible = true, -- Menampilkan file tersembunyi
					hide_dotfiles = false, -- Tidak menyembunyikan dotfiles
					hide_gitignored = true, -- Menyembunyikan file yang diabaikan git
				},
				follow_current_file = { enabled = true }, -- Menyorot file yang sedang dibuka
				hijack_netrw_behavior = "open_current", -- Membuka file dalam split, bukan tab bars
			},
			window = {
				width = 30, -- Lebar jendela
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						require("neo-tree.command").execute({ action = "close" }) -- Menutup Neo-tree setelah file dibuka
					end,
				},
			},
		})
	end,
}
