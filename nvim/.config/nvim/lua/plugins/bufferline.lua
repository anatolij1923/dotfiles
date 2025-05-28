require("bufferline").setup{
  options = {
    mode = "buffers",  -- Режим отображения буферов как вкладок
    diagnostics = "nvim_lsp",  -- Для отображения диагностик
    show_buffer_close_icons = true,  -- Иконки для закрытия буферов
    show_close_icon = false,  -- Скрыть иконку закрытия на панели
    separator_style = "slant",  -- Стиль разделителя
  },
}
