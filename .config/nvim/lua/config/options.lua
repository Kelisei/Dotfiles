vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 8
opt.shiftwidth = 8
opt.softtabstop = 8
opt.smartindent = true
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.updatetime = 50
opt.timeoutlen = 300
opt.showtabline = 2
opt.mouse = "a"

vim.filetype.add({
	extension = {
		tide = "tide",
	},
})
