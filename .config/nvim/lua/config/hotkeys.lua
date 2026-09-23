local function show_hotkeys()
	local lines = {
		"  GUIA RAPIDA DE ATAJOS (HOTKEYS)",
		"  ================================",
		"",
		"  GENERAL / ARCHIVOS",
		"  <leader>w         Guardar archivo",
		"  <leader>q         Cerrar ventana actual",
		"  <leader>x         Cerrar buffer actual",
		"  Esc               Limpiar resaltado de busqueda",
		"",
		"  NAVEGACION DE VENTANAS",
		"  Ctrl + h          Ir a ventana izquierda",
		"  Ctrl + l          Ir a ventana derecha",
		"  Ctrl + j          Ir a ventana inferior",
		"  Ctrl + k          Ir a ventana superior",
		"",
		"  BUFFERS / PESTANAS",
		"  Shift + l         Siguiente buffer",
		"  Shift + h         Buffer anterior",
		"",
		"  EXPLORADOR (NEO-TREE)",
		"  <leader>e         Abrir / enfocar / cerrar arbol",
		"  a                 (Dentro del arbol) Crear archivo o carpeta con /",
		"  d                 (Dentro del arbol) Eliminar archivo o carpeta",
		"  r                 (Dentro del arbol) Renombrar",
		"  c                 (Dentro del arbol) Copiar",
		"  m                 (Dentro del arbol) Mover o cortar",
		"  ?                 (Dentro del arbol) Ayuda interna de Neo-tree",
		"",
		"  BUSCADOR (TELESCOPE)",
		"  <leader>ff        Buscar archivos por nombre",
		"  <leader>fg        Buscar texto en todo el proyecto",
		"  <leader>fb        Buscar entre buffers abiertos",
		"  <leader>fh        Buscar temas de ayuda",
		"",
		"  GIT (NEOGIT)",
		"  <leader>gg        Abrir panel Neogit (estilo Magit)",
		"  s / u             (En Neogit) Stage / Unstage archivo o cambio",
		"  c                 (En Neogit) Menu de Commit",
		"  p / P             (En Neogit) Pull / Push",
		"  b                 (En Neogit) Ramas (Branch)",
		"  d                 (En Neogit) Ver diffs",
		"",
		"  ORG MODE",
		"  <leader>oa        Abrir vista de Agenda",
		"  <leader>oc        Captura rapida de notas (Capture contextual)",
		"  <leader>on        Abrir archivo de notas (refile.org)",
		"  <leader>oz        (En .org) Agregar nota a encabezado (:LOGBOOK:)",
		"  Tab / Shift+Tab   (En .org) Plegar / desplegar nodo o buffer",
		"  t                 (En encabezado .org) Cambiar estado TODO",
		"  op                (En encabezado .org) Cambiar prioridad [#A] / [#B] / [#C]",
		"  <leader>op        (En encabezado .org) Menu selector de prioridad",
		"  Ctrl + c Ctrl + c (En .org) Alternar casilla [ ] o evaluar tabla / formula",
		"  Enter             (En .org) Abrir enlace o evaluar tabla en #+TBLFM:",
		"  <leader>ob        (En .org) Volver de salto de enlace (:OrgBack)",
		"  <leader>oi        (En .org) Alternar notas inline tipo LSP (:OrgToggleInlineNotes)",
		"  <leader>tfe / of  (En .org) Evaluar formulas de tabla (#+TBLFM:)",
		"  <leader>oe        (En .org) Ejecutar bloque de codigo (Org Babel)",
		"  <leader>ot        (En .org) Extraer codigo (Tangle)",
		"  <leader>o?        Ver cheatsheet completo de comandos Org (:OrgShowCheatsheet)",
		"",
		"  LSP / CODIGO",
		"  K                 Ver tipo o documentacion bajo cursor",
		"  gd                Ir a definicion",
		"  gD                Ir a declaracion",
		"  gi                Ir a implementacion",
		"  gr                Buscar referencias con Telescope",
		"  <leader>rn        Renombrar simbolo en todo el proyecto",
		"  <leader>ca        Acciones de codigo o correcciones",
		"  <leader>d         Mostrar error en ventana flotante",
		"  [d / ]d           Saltar a error anterior / siguiente",
		"",
		"  AUTOCOMPLETADO (INSERT MODE)",
		"  Tab / Shift+Tab   Siguiente / anterior sugerencia",
		"  Enter             Confirmar seleccion",
		"  Ctrl + Espacio    Forzar autocompletado manual",
		"",
		"  Presiona 'q' o 'Esc' para cerrar esta ventana.",
	}

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "help"

	local width = 64
	local height = math.min(#lines, vim.o.lines - 4)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Atajos de Teclado ",
		title_pos = "center",
	})

	local close_win = function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	vim.keymap.set("n", "q", close_win, { buffer = buf, nowait = true })
	vim.keymap.set("n", "<Esc>", close_win, { buffer = buf, nowait = true })
end

vim.api.nvim_create_user_command("Hotkeys", show_hotkeys, {})
vim.keymap.set("n", "<leader>?", show_hotkeys, { desc = "Mostrar atajos" })
