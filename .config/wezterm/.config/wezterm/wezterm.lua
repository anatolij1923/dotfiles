local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = 16

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 30

config.color_scheme = "Kanagawa Dragon (Gogh)"

local colors = require("colors")
config.colors = colors

config.enable_scroll_bar = false

config.window_padding = {
	top = 0,
	bottom = 0,
	left = 0,
	right = 0,
}

config.window_background_opacity = 1

return config
