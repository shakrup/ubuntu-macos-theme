# macos-ubuntu.sh

Основной скрипт оформления системы.

## Что делает

1. Устанавливает зависимости через apt
2. Создаёт backup `~/.themes` и `~/.icons` в `~/backup_themes_YYYYMMDD_HHMMSS`
3. Клонирует и устанавливает WhiteSur GTK тему, иконки, курсоры
4. Устанавливает шрифты San Francisco в `~/.fonts`
5. Скачивает обои Catalina в `~/Pictures/macos-wallpaper.jpg`
6. Собирает и устанавливает Blur My Shell
7. Применяет настройки через gsettings
8. Настраивает dash-to-dock

## Ключевые пути

| Путь | Содержимое |
|------|------------|
| `~/.themes/` | GTK тема WhiteSur |
| `~/.icons/` | Иконки и курсоры WhiteSur |
| `~/.fonts/` | San Francisco TTF |
| `~/Pictures/macos-wallpaper.jpg` | Обои |
| `~/macos-setup.log` | Лог выполнения |
| `~/backup_themes_*/` | Backup старых тем |

## Параметры темы WhiteSur

```bash
# Цвет (light/dark)
./install.sh -c dark

# Акцентный цвет
./install.sh -t blue   # blue, purple, pink, red, orange, yellow, green

# Стиль углов
./install.sh -N mojave  # mojave, monterey
```

## Откат

```bash
rm -rf ~/.themes ~/.icons
cp -r ~/backup_themes_*/.themes ~/
cp -r ~/backup_themes_*/.icons ~/
```
