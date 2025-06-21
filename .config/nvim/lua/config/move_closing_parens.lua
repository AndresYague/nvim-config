-- Reverse a bracket
local reverse_bracket = {}
reverse_bracket[")"] = "%("
reverse_bracket["]"] = "%["
reverse_bracket["}"] = "%{"
reverse_bracket['"'] = '"'
reverse_bracket["'"] = "'"

local correct_match = {}
correct_match[")"] = "%)"
correct_match["]"] = "%]"
correct_match["}"] = "%}"
correct_match['"'] = '"'
correct_match["'"] = "'"

local closing_brackets = "[])}\"']"

-- Move character in "from" to "to"
---@param str string
---@param from integer
---@param to integer
local move_char = function(str, from, to)
    local str_split = string.sub(str, 1, from - 1)
    str_split = str_split .. string.sub(str, from + 1, to)
    str_split = str_split .. string.sub(str, from, from)
    str_split = str_split .. string.sub(str, to + 1)

    return str_split
end

-- Move match with Ctrl+e to encompass next word
-- For example, if moving parens do ()here -> (here)
---@param line string
---@param col integer
---@param pattern string
---@return boolean
local move_match = function(line, col, pattern)
	-- If we do not find "closing", exit
	local closing = string.find(line, pattern, col)
	if not closing then
		return false
	end

	-- Find next closing bracket
	local next_closing = string.find(line, closing_brackets, closing + 1)

	-- Find the last thing before a space after the closing parenthesis
	local next_space = string.find(line, "[^%s]%s", closing + 1) or string.find(line, "[^%s]$", closing + 1)

	-- Find the end of the next word
	local next_word = string.find(line, "%w[^%w]", closing + 1) or string.find(line, "%w$", closing + 1)

	-- Exit if next_space is nil
	if not next_space then
		return false
	end

	-- At minimum, we are going to the "next space"
	local position_bracket = next_space

	-- Check if the "next word" comes before
	if next_word then
		position_bracket = math.min(next_word, position_bracket)
	end

	-- Check if we are somehow crossing brackets and stop before that
	if next_closing then
		position_bracket = math.min(next_closing - 1, position_bracket)
	end

	-- If we do not move it, return false
	if position_bracket == closing then
		return false
	end

	-- Insert the pattern in the new position
	-- and remove it from the original position
    line = move_char(line, closing, position_bracket)

    -- Write new line
	vim.api.nvim_set_current_line(line)

	return true
end

-- Pattern match different types of closing "bracket" and move them
local move_closing = function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] -- x-axis of cursor
	local after_cursor = string.sub(line, col + 1)
	local before_cursor = string.reverse(string.sub(line, 1, col))

	for match in string.gmatch(after_cursor, closing_brackets) do
		-- If there is another bracket right after the first one,
		-- do that one instead
		if string.find(after_cursor, correct_match[match] .. closing_brackets) then
			goto continue
		end

		-- Make sure we are inside parentheses
		if string.find(before_cursor, reverse_bracket[match]) then
			-- Moved match correctly, exit loop
			if move_match(line, col + 1, match) then
				break
			end
		end

		::continue::
	end
end

-- Setup the keymaps
vim.keymap.set("n", "<C-E>", move_closing, { desc = "Move parenthesis around next word" })
vim.keymap.set("i", "<C-E>", move_closing, { desc = "Move parenthesis around next word" })
