return {
	-- Основные
	foreground = "{{colors.on_surface.default.hex}}",
	background = "{{colors.surface.default.hex}}",

	-- Курсор
	cursor_bg = "{{colors.primary.default.hex}}",
	cursor_fg = "{{colors.surface.default.hex}}",
	cursor_border = "{{colors.primary.default.hex}}",

	-- Выделение
	selection_bg = "{{colors.primary_container.default.hex}}",
	selection_fg = "{{colors.on_primary_container.default.hex}}",

	-- Скроллбар
	scrollbar_thumb = "{{colors.outline.default.hex}}",

	-- Сплиттеры
	split = "{{colors.outline_variant.default.hex}}",

	-- Статус-бар
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

	-- Панель с подсказками клавиш
	-- quick_select_label_bg = "{{colors.primary_container.default.hex}}",
	-- quick_select_label_fg = "{{colors.on_primary_container.default.hex}}",
	-- quick_select_match_bg = "{{colors.secondary_container.default.hex}}",
	-- quick_select_match_fg = "{{colors.on_secondary_container.default.hex}}",

	-- Панель поиска
	-- search = {
	-- 	matches = {
	-- 		bg_color = "{{colors.secondary_container.default.hex}}",
	-- 		fg_color = "{{colors.on_secondary_container.default.hex}}",
	-- 	},
	-- 	focused_match = {
	-- 		bg_color = "{{colors.tertiary_container.default.hex}}",
	-- 		fg_color = "{{colors.on_tertiary_container.default.hex}}",
	-- 	},
	-- },
}
