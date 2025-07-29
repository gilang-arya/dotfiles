return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "night", -- atau "night", "moon", "day"
			transparent = false,
			on_highlights = function(highlights, colors)
				highlights.Normal = {
					bg = "#15161E", -- ganti dengan warna latar belakang yang kamu inginkan
					fg = colors.fg,
				}
			end,
		})
		-- load the colorscheme here
		vim.cmd([[colorscheme tokyonight-night]])
	end,
}
