local theme_cache = vim.fn.stdpath("state") .. "/colorscheme"

local function load_theme()
	local f = io.open(theme_cache, "r")
	if not f then
		return nil
	end
	local theme = f:read("*all"):gsub("%s+", "")
	f:close()
	return (theme ~= "") and theme or nil
end

local theme = load_theme()

if theme and theme ~= "default" then
	pcall(vim.cmd.colorscheme, theme)
end
