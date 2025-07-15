return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers", -- bisa juga "tabs"
				separator_style = "slant",
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						text_align = "center",
						separator = true,
					},
				},
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or ""
					return " " .. icon .. count
				end,
				max_name_length = 18,
				max_prefix_length = 15,
				truncate_names = true,
			},
		})
	end,
}

