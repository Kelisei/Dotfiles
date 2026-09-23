return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "pyright", "clangd", "omnisharp" },
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
		})

		vim.lsp.config("clangd", {
			capabilities = capabilities,
		})

		vim.lsp.config("omnisharp", {
			capabilities = capabilities,
			settings = {
				FormattingOptions = {
					EnableEditorConfigSupport = true,
				},
				RoslynExtensionsOptions = {
					enableAnalyzersSupport = true,
				},
			},
		})

		vim.lsp.config("pyright", {
			capabilities = capabilities,
			before_init = function(_, config)
				local p = config.root_dir and (config.root_dir .. "/.venv/bin/python")
				if p and vim.fn.filereadable(p) == 1 then
					config.settings = config.settings or {}
					config.settings.python = config.settings.python or {}
					config.settings.python.pythonPath = p
				end
			end,
		})

		vim.lsp.enable({ "lua_ls", "pyright", "clangd", "omnisharp" })

		local function ensure_clang_format(bufnr)
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname == "" then
				return
			end
			local dir = vim.fs.dirname(bufname)
			local found = vim.fs.find(".clang-format", { upward = true, path = dir })
			if #found > 0 then
				return
			end

			local root = vim.fs.root(bufnr, { ".git", "compile_commands.json", "build" }) or dir
			if vim.fn.isdirectory(root) ~= 1 then
				return
			end
			local clang_format_file = root .. "/.clang-format"

			local shiftwidth = vim.bo[bufnr].shiftwidth
			if shiftwidth == 0 then
				shiftwidth = vim.bo[bufnr].tabstop
			end
			local tabwidth = vim.bo[bufnr].tabstop
			local use_tab = vim.bo[bufnr].expandtab and "Never" or "Always"

			local lines = {
				"BasedOnStyle: LLVM",
				"IndentWidth: " .. shiftwidth,
				"TabWidth: " .. tabwidth,
				"UseTab: " .. use_tab,
			}
			pcall(vim.fn.writefile, lines, clang_format_file)
		end

		local function ensure_editorconfig(bufnr)
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname == "" then
				return
			end
			local dir = vim.fs.dirname(bufname)
			local found = vim.fs.find(".editorconfig", { upward = true, path = dir })
			if #found > 0 then
				return
			end

			local root = vim.fs.root(bufnr, function(name)
				return name:match("%.csproj$") or name:match("%.sln$") or name:match("%.slnx$") or name == ".git"
			end) or dir
			if vim.fn.isdirectory(root) ~= 1 then
				return
			end
			local editorconfig_file = root .. "/.editorconfig"

			local shiftwidth = vim.bo[bufnr].shiftwidth
			if shiftwidth == 0 then
				shiftwidth = vim.bo[bufnr].tabstop
			end
			if shiftwidth == 0 then
				shiftwidth = 8
			end
			local indent_style = vim.bo[bufnr].expandtab and "space" or "tab"

			local lines = {
				"root = true",
				"",
				"[*]",
				"indent_style = " .. indent_style,
				"indent_size = " .. shiftwidth,
				"tab_width = " .. shiftwidth,
				"",
				"[*.cs]",
				"csharp_new_line_before_open_brace = none",
				"csharp_new_line_before_else = false",
				"csharp_new_line_before_catch = false",
				"csharp_new_line_before_finally = false",
				"csharp_new_line_before_members_in_object_initializers = false",
				"csharp_new_line_before_members_in_anonymous_types = false",
			}
			pcall(vim.fn.writefile, lines, editorconfig_file)
		end

		local function format_csharp(bufnr)
			local clang_format = vim.fn.exepath("clang-format")
			if clang_format == "" then
				clang_format = vim.fn.expand("~/.local/share/nvim/mason/bin/clang-format")
			end
			if vim.fn.executable(clang_format) ~= 1 then
				return
			end
			local shiftwidth = vim.bo[bufnr].shiftwidth
			if shiftwidth == 0 then
				shiftwidth = vim.bo[bufnr].tabstop
			end
			if shiftwidth == 0 then
				shiftwidth = 8
			end
			local tabwidth = vim.bo[bufnr].tabstop
			if tabwidth == 0 then
				tabwidth = shiftwidth
			end
			local use_tab = vim.bo[bufnr].expandtab and "Never" or "Always"
			local style = string.format("{BasedOnStyle: LLVM, BreakBeforeBraces: Attach, IndentWidth: %d, TabWidth: %d, UseTab: %s}", shiftwidth, tabwidth, use_tab)
			local fname = vim.api.nvim_buf_get_name(bufnr)
			if fname == "" then
				fname = "file.cs"
			end
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local content = table.concat(lines, "\n")
			local res = vim.system({ clang_format, "--assume-filename=" .. fname, "--style=" .. style }, { stdin = content }):wait()
			if res.code == 0 and res.stdout and #res.stdout > 0 then
				local out_lines = vim.split(res.stdout, "\n", { trimempty = false })
				if #out_lines > 0 and out_lines[#out_lines] == "" then
					table.remove(out_lines, #out_lines)
				end
				local view = vim.fn.winsaveview()
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, out_lines)
				vim.fn.winrestview(view)
			end
		end

		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function(args)
				local ft = vim.bo[args.buf].filetype
				if ft == "c" or ft == "cpp" or ft == "objc" or ft == "objcpp" or ft == "cuda" then
					ensure_clang_format(args.buf)
					vim.lsp.buf.format({ async = false })
				elseif ft == "cs" then
					ensure_editorconfig(args.buf)
					format_csharp(args.buf)
				else
					vim.lsp.buf.format({ async = false })
				end
			end,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.name == "omnisharp" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				local bufmap = function(mode, lhs, rhs)
					vim.keymap.set(mode, lhs, rhs, { buffer = event.buf })
				end

				bufmap("n", "K", vim.lsp.buf.hover)
				bufmap("n", "gd", vim.lsp.buf.definition)
				bufmap("n", "gD", vim.lsp.buf.declaration)
				bufmap("n", "gi", vim.lsp.buf.implementation)
				bufmap("n", "gr", vim.lsp.buf.references)
				bufmap("n", "<leader>rn", vim.lsp.buf.rename)
				bufmap("n", "<leader>ca", vim.lsp.buf.code_action)
				bufmap("n", "<leader>d", vim.diagnostic.open_float)
			end,
		})

		vim.diagnostic.config({
			underline = true,
			virtual_text = {
				spacing = 4,
				prefix = "●",
			},
			signs = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end,
}
