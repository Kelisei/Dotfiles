return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "ruby", "c_sharp" },
			highlight = { enable = true },
		})
		vim.treesitter.language.register("ruby", "tide")
	end,
}
