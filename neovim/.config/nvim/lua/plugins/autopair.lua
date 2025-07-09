return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")
		npairs.setup({
			check_ts = true, -- gunakan Treesitter untuk pairing kontekstual
		})

		-- Integrasi dengan nvim-cmp
		local ok_cmp, cmp = pcall(require, "cmp")
		if ok_cmp then
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end
	end,
}

