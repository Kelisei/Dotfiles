return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>" },
		{ "<leader>x", "<cmd>bdelete<cr>" },
	},
	opts = {
		options = {
			always_show_bufferline = true,
			diagnostics = "nvim_lsp",
			separator_style = "slant",
			offsets = {
				{
					filetype = "neo-tree",
					text = "Explorador",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
	},
}
