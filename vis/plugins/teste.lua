-- complete word at primary selection location using vis-complete(1)

vis:map(vis.modes.INSERT, "<C-x><C-n>", function()
	local win = vis.win
	local file = win.file
	local pos = win.selection.pos
	if not pos then return end
	local range = file:text_object_longword(pos > 0 and pos-1 or pos);
	if not range then return end
	if range.finish > pos then range.finish = pos end
	if range.start == range.finish then return end
	local prefix = file:content(range)
	if not prefix then return end

	local function concat_keys(tbl)
		local keys = {}
		for k in pairs(tbl) do
			table.insert(keys, k)
		end
		return table.concat(keys, "\n"), #keys
	end
	
	local path = os.getenv('XDG_CONFIG_HOME')..'/vis/dict/'..win.syntax..'.dict'
	local dict = io.open(path, 'r')
	local indent_patt = "^[ \t\v\f]+"
	local candidates = {}
	for l in io.lines(path) do
		local unindented = l:gsub(indent_patt, "")
		local start, finish = unindented:find(prefix, 1, true)
		if start == 1 and finish < #unindented then
			candidates[unindented] = true
		end
	end
	local candidates_str, n = concat_keys(candidates)
	local command = string.format([[echo -e "%s" | vis-menu -l %d]],
		candidates_str,
		math.min(n, math.ceil(vis.win.height / 2)))
	local status, output = vis:pipe(file, {start = 0, finish = 0}, command)
	file:insert(pos, output:sub(#prefix +1):gsub("\n$", ''))
	win.selection.pos = pos + #output
end, "Completar palavras em dicionário da syntax")
