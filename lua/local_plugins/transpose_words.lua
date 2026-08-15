---@param word string word to find index
---@param line string line to find word in
---@param col integer?,integer? cursor index 1-indexed
local function get_word_index(word, line, col)
  -- Find where the current word is
  local find_b, find_e = assert(line:find(word, 1, true))
  local w_index_b, w_index_e = find_b, find_e

  local i = 0
  while find_b < col do
    w_index_b, w_index_e = find_b, find_e
    ---@diagnostic disable-next-line: cast-local-type
    find_b, find_e = line:find(word, w_index_b + 1, true)

    if find_b == nil then
      break
    end
    assert(find_e)

    w_index_b, w_index_e = find_b, find_e

    i = i + 1
    if i > #line then
      return nil
    end
  end

  return w_index_b, w_index_e
end

-- Swap the current word with the next one. Do so by looking at the closest
-- word in front of the cursor and behind the cursor
local function swap_words()
  -- Line to perform operations in
  local line = vim.api.nvim_get_current_line()

  -- Look for the current word
  local cword = vim.fn.expand '<cword>'

  -- Return if empty
  if #cword == 0 then
    return
  end

  -- Get the current cursor column before moving the cursor below
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- Move the cursor to the next word and get it as well
  vim.api.nvim_feedkeys('w', 'nx', false)
  local nword = vim.fn.expand '<cword>'

  -- Return if empty or the words are identical
  if #nword == 0 or cword == nword then
    return
  end

  -- Now change the words

  -- Find the words indices
  local b1, e1 = get_word_index(cword, line, col)
  local b2, e2 =
    get_word_index(nword, line, vim.api.nvim_win_get_cursor(0)[2] + 1)

  if b1 == nil or b2 == nil then
    return
  end

  -- Reform line with the words swapped
  line = line:sub(1, b1 - 1)
    .. nword
    .. line:sub(e1 + 1, b2 - 1)
    .. cword
    .. line:sub(e2 + 1)

  vim.api.nvim_set_current_line(line)
end

vim.keymap.set('n', '<M-t>', swap_words)
