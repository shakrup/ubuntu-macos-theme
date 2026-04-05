# ubuntu-macos-theme

Набор скриптов для оформления Ubuntu 25.10 в стиле macOS.

## Результат

| Компонент | До | После |
|-----------|-----|-------|
| Система | Стандартный GNOME | WhiteSur тема + иконки + курсоры |
| Терминал | Стандартный | oh-my-posh + MesloLGS NF |
| Файловый менеджер | Стандартный Nautilus | Finder-style тёмная панель |

## Структура

```
ubuntu-macos-theme/
├── scripts/
│   ├── macos-ubuntu.sh      # Тема, иконки, шрифты, обои, dok
│   ├── terminal-macos.sh    # oh-my-posh тема + шрифт MesloLGS NF
│   └── nautilus-macos.sh    # Nautilus в стиле Finder
├── docs/
│   ├── macos-ubuntu.md      # Детали скрипта оформления
│   ├── terminal-macos.md    # Детали настройки терминала
│   └── nautilus-macos.md    # Детали настройки Nautilus
├── README.md
└── CHANGELOG.md
```

## Быстрый старт

```bash
git clone https://github.com/YOUR_USERNAME/ubuntu-macos-theme.git
cd ubuntu-macos-theme
```

> ⚠️ Не запускать от root. Скрипты сами запросят sudo где нужно.

### Полная установка

```bash
./scripts/macos-ubuntu.sh      # ~10 мин
./scripts/terminal-macos.sh    # ~2 мин
./scripts/nautilus-macos.sh    # ~1 мин
```

Каждый скрипт независим — запускай только нужные.

### Требования

| Требование | Версия |
|------------|--------|
| Ubuntu | 25.10 |
| GNOME | 47+ |
| oh-my-posh | любая (только для terminal-macos.sh) |
| zsh | любая (только для terminal-macos.sh) |

## Откат

```bash
# Темы
rm -rf ~/.themes ~/.icons
cp -r ~/backup_themes_*/.themes ~/   # выбрать нужный backup
cp -r ~/backup_themes_*/.icons ~/

# Terminal
cp ~/.zshrc.bak.* ~/.zshrc           # выбрать нужный backup

# Nautilus
gsettings reset-recursively org.gnome.nautilus.preferences
# Удалить блок CSS между комментариями в ~/.config/gtk-4.0/gtk.css
```

## Компоненты

| Компонент | Источник |
|-----------|----------|
| WhiteSur GTK тема | [vinceliuice/WhiteSur-gtk-theme](https://github.com/vinceliuice/WhiteSur-gtk-theme) |
| WhiteSur иконки | [vinceliuice/WhiteSur-icon-theme](https://github.com/vinceliuice/WhiteSur-icon-theme) |
| WhiteSur курсоры | [vinceliuice/WhiteSur-cursors](https://github.com/vinceliuice/WhiteSur-cursors) |
| San Francisco шрифт | [supermarin/YosemiteSanFranciscoFont](https://github.com/supermarin/YosemiteSanFranciscoFont) |
| MesloLGS NF шрифт | [romkatv/powerlevel10k-media](https://github.com/romkatv/powerlevel10k-media) |
| Blur My Shell | [aunetx/blur-my-shell](https://github.com/aunetx/blur-my-shell) |
| macOS звуки | [B00merang-Project/macOS-sounds](https://github.com/B00merang-Project/macOS-sounds) |
| Обои Catalina | [linuxdotexe/macOS-Catalina-Wallpaper](https://github.com/linuxdotexe/macOS-Catalina-Wallpaper) |

## Лицензия

MIT
