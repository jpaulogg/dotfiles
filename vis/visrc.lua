-- load standard vis module, providing parts of the Lua API
require('vis')

-- PLUGINS --------------------------------------------------------------------
require('plugins/surround')
require('plugins/statusline')
require('plugins/ins-completion')

-- EVENTOS --------------------------------------------------------------------

-- inicialização
vis.events.subscribe(vis.events.INIT, function()
  	vis:command('set theme zenburn_alpha')
	vis:command('set autoindent')
	vis:command('set tabwidth 4')
end)

-- novas janelas
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set relativenumbers')
end)

--- configurações por extensão (filetype)
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	if win.syntax == 'text' then
		vis:command('set expandtab')
	end
end)

-- COMANDOS -------------------------------------------------------------------

vis:command_register('Sp', function(argv)
	local file = vis.win.file
	local path = argv[1] or file.path
	local cmd = string.format("!st -e vis '%s' &", path)
	vis:command(cmd)
end, "Abrir arquivo em nova janela de terminal")

-- ATALHOS DE TACLADO ---------------------------------------------------------

-- clipboard
vis:map(vis.modes.VISUAL, 'D', '"+d') 
vis:map(vis.modes.VISUAL, 'Y', '"+y')
vis:map(vis.modes.VISUAL, 'P', '"+p')

-- usando "alt" como "escape"
vis:map(vis.modes.INSERT, '<M-u>', '<Escape>u')
vis:map(vis.modes.INSERT, '<M-j>', '<Escape>j')
vis:map(vis.modes.INSERT, '<M-k>', '<Escape>k')
vis:map(vis.modes.INSERT, '<M-h>', '<Escape>h')
vis:map(vis.modes.INSERT, '<M-l>', '<Escape>l')

-- o contrário de J, separando a linha
vis:map(vis.modes.NORMAL, 'K', 's<Enter><C-c>')

-- mapear "!" como "|" para facilitar a vida quando o teclado não tiver "|"
vis:map(vis.modes.NORMAL, '!', '|')
vis:map(vis.modes.VISUAL, '!', '|')

-- anular J no modo visual
vis:unmap(vis.modes.VISUAL, 'J')

-- ignore case
vis:map(vis.modes.NORMAL, 'g/', '<vis-search-forward>(?i)')

-- formatar texto com gq
vis:operator_new("gq", function(file, range, pos)
	local status, out, err = vis:pipe(file, range, "par jw80")
	if not status then
	vis:info(err)
	else
		file:delete(range)
		file:insert(range.start, out)
	end
	return range.start -- new cursor location
end, "Formata parágrafo com o programa par(1)")