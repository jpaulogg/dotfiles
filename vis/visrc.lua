-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
	vis:command('set theme zenburn_mod')
	vis:command('set autoindent')
	vis:command('set ignorecase')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Your per window configuration options e.g.
	vis:command('set relativenumbers')
end)
