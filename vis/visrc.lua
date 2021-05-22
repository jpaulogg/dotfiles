-- load standard vis module, providing parts of the Lua API
require('vis')

-- PLUGINS --------------------------------------------------------------------
require('plugins/surround')
require('plugins/complete-line')
require('plugins/complete-dict')
require('plugins/statusline')

-- ATALHOS DE TACLADO ---------------------------------------------------------

-- novo terminal com o administrador de arquivos no diretório atual
vis:map(vis.modes.NORMAL, 'gd', ':!$TERMINAL -e $FILEMANAGER $PWD &<Enter>')

-- clipboard
vis:map(vis.modes.VISUAL, ' d', '"+d')
vis:map(vis.modes.VISUAL, ' y', '"+y')
vis:map(vis.modes.VISUAL, ' p', '"+p')
vis:map(vis.modes.NORMAL, ' p', '"+p')

-- selecionar colunas divididas por espaços e vírgulas (útil para alinhamento)
vis:map(vis.modes.VISUAL, ' ,', ':y/, +<Enter><vis-selections-align-indent-left>')

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

-- o contrário de J, separando a linha
vis:map(vis.modes.NORMAL, 'K', ':|fmt<Enter>')

-- ignore case
vis:map(vis.modes.NORMAL, ' /', '/(?i)')

-- usando 'alt' como 'escape'
vis:map(vis.modes.INSERT, '<M-u>', '<Escape>u')
vis:map(vis.modes.INSERT, '<M-j>', '<Escape>j')
vis:map(vis.modes.INSERT, '<M-l>', '<Escape>l')

-- EVENTOS --------------------------------------------------------------------

-- na inicialização
vis.events.subscribe(vis.events.INIT, function()
  	vis:command('set theme zenburn_alpha')
	vis:command('set autoindent')
	vis:command('set tabwidth 4')
	vis:command('set shell sh')
end)

-- depois de abrir uma nova janela
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set relativenumbers')
end)

-- configurações por extensão

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

