-- Author: Georgi Kirilov
--
-- You can contact me via email to the posteo.net domain.
-- The local-part is the Z code for "Place a competent operator on this circuit."

local vis = vis

-- copied from vis.h
local VIS_MOVE_NOP = 60

local function concat_keys(tbl)
	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end
	return table.concat(keys, "\n"), #keys
end

local function line_complete()
	local file = vis.win.file
	local sel = vis.win.selection
	local cur_line = file.lines[sel.line]
	local indent_patt = "^[ \t\v\f]+"
	local prefix = cur_line:sub(1, sel.col - 1):gsub(indent_patt, "")
	local candidates = {}
	for l in file:lines_iterator() do
		local unindented = l:gsub(indent_patt, "")
		local start, finish = unindented:find(prefix, 1, true)
		if start == 1 and finish < #unindented then
			candidates[unindented] = true
		end
	end
	local candidates_str, n = concat_keys(candidates)
	if n < 2 then
		if n == 1 then
			vis:insert(candidates_str:sub(#prefix + 1))
		end
		return
	end
	-- XXX: with too many candidates this command will become longer that the shell can handle:
	local command = string.format([[echo -e "%s" | vis-menu -l %d]],
		candidates_str,
		math.min(n, math.ceil(vis.win.height / 2)))
	local status, output = vis:pipe(file, {start = 0, finish = 0}, command)
	if n > 0 and status == 0 then
		vis:insert(output:sub(#prefix + 1):gsub("\n$", ""))
	end
end

local function selection_by_pos(pos)
	for s in vis.win:selections_iterator() do
		if s.pos == pos then
			return s
		end
	end
end

local function insert_char(direction)
	return function(file, _, pos)
		local sel = selection_by_pos(pos)
		local line = file.lines[sel.line + direction]
		local char = line and line:sub(sel.col, sel.col)
		if not char then return pos end
		file:insert(pos, char)
		return pos + #char
	end
end

local function operator(handler)
	local id = vis:operator_register(handler)
	return id >= 0 and function()
		vis:operator(id)
		vis:motion(VIS_MOVE_NOP)
	end
end

vis.events.subscribe(vis.events.INIT, function()
	vis:map(vis.modes.INSERT, "<C-y>", operator(insert_char(-1)), "Insert the character which is above the cursor")
	vis:map(vis.modes.INSERT, "<C-e>", operator(insert_char(1)), "Insert the character which is below the cursor")
	vis:map(vis.modes.INSERT, "<C-x><C-l>", line_complete, "Complete the current line")
end)
