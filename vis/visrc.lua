-- load standard vis module, providing parts of the Lua API
require('vis')

-- PLUGINS --------------------------------------------------------------------
require('plugins/surround')
--require('plugins/complete-dict')
--require('plugins/complete-line')
--require('plugins/complete-char')
--require('plugins/complete-keyword')
require('plugins/ins-completion')
require('plugins/statusline')

-- EVENTOS --------------------------------------------------------------------

-- inicialização
vis.events.subscribe(vis.events.INIT, function()
  	vis:command('set theme zenburn_alpha')
	vis:command('set autoindent')
	vis:command('set tabwidth 4')
	vis:command('set shell /bin/sh')
end)

-- novas janelas
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set relativenumbers')
end)

-- configurações por extensão (filetype)
settings = { rstats = {'set tabwidth 2', nil} }

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	if settings == nil then return end
	local window_settings = settings[win.syntax]
	if type(local_settings) == 'table' then
		for _, opt in pairs(local_settings) do
			vis:command(opt)
		end
	end
end)

-- COMANDOS -------------------------------------------------------------------

-- administrador de arquivos
vis:command_register('lf', function(argv)
	local directory = argv[1] or ''
	-- comando two-panels no arquivo lfrc
	local cmd =string.format("$TERMINAL -e lf -command two-panels %s 2> /dev/null &", directory)
	vis:command('!'..cmd)
end, "Abre o programa lf(1) em uma nova janela")

-- ATALHOS DE TACLADO ---------------------------------------------------------

-- clipboard
vis:map(vis.modes.VISUAL, ' d', '"+d')
vis:map(vis.modes.VISUAL, ' y', '"+y')
vis:map(vis.modes.VISUAL, ' p', '"+p')

-- usando 'alt' como 'escape'
vis:map(vis.modes.INSERT, '<M-u>', '<Escape>u')
vis:map(vis.modes.INSERT, '<M-j>', '<Escape>j')
vis:map(vis.modes.INSERT, '<M-k>', '<Escape>k')
vis:map(vis.modes.INSERT, '<M-h>', '<Escape>h')
vis:map(vis.modes.INSERT, '<M-l>', '<Escape>l')

-- selecionar colunas divididas por espaços e vírgulas (útil para alinhamento)
vis:map(vis.modes.VISUAL, ' ,', ':y/,\\s+<Enter>')

-- o contrário de J, separando a linha
vis:map(vis.modes.NORMAL, 'K', ':|fmt<Enter>')

-- mapear '!' como '|' para facilitar a vida quando o teclado não tiver '|'
vis:map(vis.modes.NORMAL, '!', '|')
vis:map(vis.modes.VISUAL, '!', '|')

-- anular J no modo visual
vis:unmap(vis.modes.VISUAL, 'J')

-- ignore case
vis:map(vis.modes.NORMAL, ' /', '/(?i)')

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
