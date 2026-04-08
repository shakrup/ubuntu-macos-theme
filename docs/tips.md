# Полезные команды и настройки

Всё что было настроено вручную в процессе — для быстрого применения или справки.

## Dok панель

```bash
# Прозрачный фон
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode  'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock customize-alphas   true
gsettings set org.gnome.shell.extensions.dash-to-dock min-alpha          0.0
gsettings set org.gnome.shell.extensions.dash-to-dock max-alpha          0.0
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.0

# Отключить blur для дока (Blur My Shell)
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur false

# Intellihide — прятаться только когда окно перекрывает dok
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed      false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide      true
gsettings set org.gnome.shell.extensions.dash-to-dock autohide         true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide-mode 'FOCUS_APPLICATION_WINDOWS'
# Режимы: FOCUS_APPLICATION_WINDOWS | MAXIMIZED_WINDOWS | ALL_WINDOWS

# Позиция дока
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
```

## Кнопки управления окном

```bash
# Слева как в macOS
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Справа как в Windows
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
```

## GTK CSS — кнопки окна в стиле macOS

Файл: `~/.config/gtk-4.0/gtk.css`

```css
/* macOS-style window buttons (GTK4) */
headerbar {
    min-height: 32px;
    padding: 0;
}

windowcontrols > button {
    min-width: 16px;
    min-height: 16px;
    margin: 0 4px;
    padding: 0;
    border-radius: 999px;
    border: none;
    box-shadow: none;
}

windowcontrols button image {
    opacity: 0;
    -gtk-icon-size: 16px;
    transform: scale(1.3);
}

windowcontrols > button.close    image { color: #000; }
windowcontrols > button.minimize image { color: #000; }
windowcontrols > button.maximize image { color: #000; }

windowcontrols > button:hover image {
    opacity: 1;
}

headerbar windowcontrols {
    margin-top: 8px;
    margin-bottom: 8px;
}

windowcontrols > button.close    { background-color: #FF5F57; }
windowcontrols > button.minimize { background-color: #FFBD2E; }
windowcontrols > button.maximize { background-color: #28C841; }

windowcontrols > button.close:hover    { background-color: #FF3B30; }
windowcontrols > button.minimize:hover { background-color: #FFB000; }
windowcontrols > button.maximize:hover { background-color: #00C425; }
```

## Иконки

```bash
# Применить WhiteSur (установлен скриптом)
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"

# Установить и применить Tela (альтернатива, цветные)
git clone --depth=1 https://github.com/vinceliuice/Tela-icon-theme.git /tmp/tela
/tmp/tela/install.sh -a
gsettings set org.gnome.desktop.interface icon-theme "Tela-dark"
```

## Шрифты

```bash
# San Francisco (установлен скриптом)
gsettings set org.gnome.desktop.interface font-name            "San Francisco Display 11"
gsettings set org.gnome.desktop.interface document-font-name   "San Francisco Text 11"
gsettings set org.gnome.desktop.interface monospace-font-name  "SF Mono 12"
gsettings set org.gnome.desktop.wm.preferences titlebar-font   "San Francisco Display Bold 11"

# Сбросить на Ubuntu
gsettings set org.gnome.desktop.interface font-name            "Ubuntu 11"
gsettings set org.gnome.desktop.interface monospace-font-name  "Ubuntu Mono 13"
```

## Обои

```bash
gsettings set org.gnome.desktop.background picture-uri      "file:///home/$USER/Pictures/macos-wallpaper.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USER/Pictures/macos-wallpaper.jpg"
gsettings set org.gnome.desktop.background picture-options  "zoom"
```

## Nautilus

```bash
# Сбросить все настройки Nautilus
gsettings reset-recursively org.gnome.nautilus.preferences
gsettings reset-recursively org.gnome.nautilus.list-view
gsettings reset-recursively org.gnome.nautilus.window-state

# Показать/скрыть скрытые файлы
gsettings set org.gnome.nautilus.preferences show-hidden-files true
gsettings set org.gnome.nautilus.preferences show-hidden-files false
```

## oh-my-posh

```bash
# Применить тему без перезапуска
source ~/.zshrc

# Сменить тему
oh-my-posh init zsh --config ~/.config/oh-my-posh/macos.omp.json

# Посмотреть все встроенные темы
oh-my-posh get shell themes
```

## Откат

```bash
# Темы
rm -rf ~/.themes ~/.icons
cp -r ~/backup_themes_*/.themes ~/
cp -r ~/backup_themes_*/.icons ~/

# Terminal (.zshrc)
cp ~/.zshrc.bak.* ~/.zshrc   # выбрать нужный

# GTK CSS
cp ~/.config/gtk-4.0/gtk.css.bak.* ~/.config/gtk-4.0/gtk.css

# Кнопки окна
gsettings reset org.gnome.desktop.wm.preferences button-layout

# Иконки
gsettings reset org.gnome.desktop.interface icon-theme
```
