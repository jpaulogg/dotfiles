-- Author: Georgi Kirilov

-- You can contact me via email to the posteo.net domain.
-- The local-part is the Z code for "Place a competent operator on this circuit."

vis:map(vis.modes.INSERT, "<C-x><C-l>", function()
	local win = vis.win
	local file = win.file
	local sel = win.selection
	local cur_line = file.lines[sel.line]
	local indent_patt = "^[ \t\v\f]+"
	local prefix = cur_line:sub(1, sel.col - 1):gsub(indent_patt, "")
	local cmd = [[grep --color=never '^]]..prefix..[[.' | vis-menu -l 4]]
	local status, out, err = vis:pipe(file, {start = 0, finish = file.size}, cmd)
	if status ~= 0 or not out then
		if err then vis:info(err) end
		return
	end
	vis:insert(out:sub(#prefix + 1):gsub(indent_patt, ""):gsub("\n$", ""))
end, "Complete line in current file")

-- copied from vis.h
local VIS_MOVE_NOP = 60

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
vis:map(vis.modes.INSERT, "<C-Up>", operator(insert_char(-1)), "Insert the character which is above the cursor")
vis:map(vis.modes.INSERT, "<C-Down>", operator(insert_char(1)), "Insert the character which is below the cursor")
