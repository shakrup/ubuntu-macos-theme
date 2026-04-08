# Changelog

## [1.1.0] — обновление

### macos-ubuntu.sh
- Добавлена установка Dash to Dock вместо ubuntu-dock
- Прозрачный фон дока (иконки прямо на рабочем столе)
- Отключение blur для дока в Blur My Shell
- Кнопки управления окном перенесены влево как в macOS

### nautilus-macos.sh
- Убраны несуществующие пакеты (nautilus-extension-gnome-terminal, gir1.2-nautilus-4.0)
- Рабочий CSS для кнопок управления окном в стиле macOS (GTK4)
- Упрощён CSS боковой панели

## [1.0.0] — начальный релиз

### macos-ubuntu.sh
- WhiteSur GTK тема (dark, mojave)
- WhiteSur иконки и курсоры
- Шрифты San Francisco с fallback на Ubuntu
- Обои macOS Catalina
- Blur My Shell расширение
- Настройка dash-to-dock
- Backup старых тем перед удалением
- Защита от запуска от root
- Лог-файл ~/macos-setup.log

### terminal-macos.sh
- oh-my-posh тема macos.omp.json
- Двухстрочный промпт: путь + git статус + курсор
- Цвет промпта меняется при ошибке
- Шрифт MesloLGS NF
- Автоустановка шрифта в Ptyxis / GNOME Terminal

### nautilus-macos.sh
- Вид список по умолчанию
- Папки первыми, сортировка по имени
- Тёмная боковая панель (GTK CSS)
- Тонкий скроллбар 6px
- Колонки: имя, размер, тип, дата
- Пункт «Открыть в терминале» в контекстном меню
