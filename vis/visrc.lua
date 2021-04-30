-- load standard vis module, providing parts of the Lua API
require('vis')
-- plugins
require('plugins/surround')
require('plugins/complete-line')
require('plugins/complete-dict')
require('plugins/statusline')

-- ALIASES
-- o contrário de J, separando a linha
vis:map(vis.modes.NORMAL, 'K', '=')

-- jumplist
vis:map(vis.modes.NORMAL, '<C-o>', 'g<')
vis:map(vis.modes.NORMAL, '<Tab>', 'g>')

-- inserir e deletar 4 espaços mais facilmente
vis:map(vis.modes.INSERT, '<M-i>', '    ')
vis:map(vis.modes.INSERT, '<M-h>', '<C-h><C-h><C-h><C-h>')

-- clipboard
vis:map(vis.modes.VISUAL, ' d', '"+d')
vis:map(vis.modes.VISUAL, ' y', '"+y')
vis:map(vis.modes.VISUAL, ' p', '"+p')
vis:map(vis.modes.NORMAL, ' p', '"+p')

-- ignore case
vis:map(vis.modes.NORMAL, ' /', '/(?i)')

-- EVENTOS
-- Your global configuration options
vis.events.subscribe(vis.events.INIT, function()
	vis:command('set theme zenburn_mod')
	vis:command('set autoindent')
	vis:command('set tabwidth 4')
end)

-- Your per window configuration options e.g.
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set relativenumbers')
end)

-- Configurações por extensão do arquivo (file type)
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
