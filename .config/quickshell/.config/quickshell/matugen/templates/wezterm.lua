return {
	foreground = "{{colors.on_surface.default.hex}}",
	background = "{{colors.surface.default.hex}}",

	cursor_bg = "{{colors.primary.default.hex}}",
	cursor_fg = "{{colors.surface.default.hex}}",
	cursor_border = "{{colors.primary.default.hex}}",

	selection_bg = "{{colors.primary_container.default.hex}}",
	selection_fg = "{{colors.on_primary_container.default.hex}}",

	scrollbar_thumb = "{{colors.outline.default.hex}}",

	split = "{{colors.outline_variant.default.hex}}",

	tab_bar = {
		background = "{{colors.surface_container_lowest.default.hex}}",
		active_tab = {
			bg_color = "{{colors.primary.default.hex}}",
			fg_color = "{{colors.on_primary.default.hex}}",
		},
		inactive_tab = {
			bg_color = "{{colors.surface_container_low.default.hex}}",
			fg_color = "{{colors.on_surface_variant.default.hex}}",
		},
		inactive_tab_hover = {
			bg_color = "{{colors.primary_container.default.hex}}",
			fg_color = "{{colors.on_primary_container.default.hex}}",
			italic = true,
		},
		new_tab = {
			bg_color = "{{colors.surface_container_lowest.default.hex}}",
			fg_color = "{{colors.on_surface.default.hex}}",
		},
		new_tab_hover = {
			bg_color = "{{colors.primary.default.hex}}",
			fg_color = "{{colors.on_primary.default.hex}}",
		},
	},
}
