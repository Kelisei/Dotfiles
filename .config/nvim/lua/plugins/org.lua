local local_org = vim.fn.expand("~/org.nvim")
local use_local = vim.fn.isdirectory(local_org) == 1

return {
	use_local and local_org or "Kelisei/Neovim-Org-Mode-Emulation-Plugin",
	dir = use_local and local_org or nil,
	name = "org.nvim",
	ft = { "org" },
	keys = {
		{ "<leader>oa", "<cmd>OrgAgenda<cr>", desc = "Org Agenda" },
		{ "<leader>oc", "<cmd>OrgCapture<cr>", desc = "Org Capture" },
		{ "<leader>on", "<cmd>OrgOpenNotes<cr>", desc = "Org Open Notes" },
		{ "<leader>oN", "<cmd>OrgNotes<cr>", desc = "Org Notes Viewer" },
		{ "<leader>o?", "<cmd>OrgShowCheatsheet<cr>", desc = "Org Cheatsheet" },
	},
	opts = {
		org_agenda_files = { "~/orgfiles/**/*" },
		org_default_notes_file = "~/orgfiles/refile.org",
	},
}
