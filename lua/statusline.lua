local M = {}

function M.display()
	local stl = ""

	stl = stl .. '%#DiffAdd# %{mode(".")} %#StatusLine#' -- Mode
	stl = stl .. ' '
	stl = stl .. '%f' -- File name
	stl = stl .. '%=' -- Pad to the other side
	stl = stl .. '%{&ft} ' -- File type
	stl = stl .. ' '

	return stl
end

vim.opt.statusline = "%!v:lua.require'statusline'.display()"

return M
