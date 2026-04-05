# nautilus-macos.sh

Оформление файлового менеджера Nautilus в стиле macOS Finder.

## Что делает

1. Устанавливает `nautilus-admin`, `python3-nautilus`
2. Применяет настройки поведения через gsettings
3. Добавляет GTK CSS в `~/.config/gtk-4.0/gtk.css`
4. Создаёт скрипт «Открыть в терминале» в контекстном меню
5. Перезапускает Nautilus

## Настройки gsettings

| Ключ | Значение | Эффект |
|------|----------|--------|
| `default-folder-viewer` | `list-view` | Вид списком |
| `sort-directories-first` | `true` | Папки первыми |
| `show-hidden-files` | `false` | Скрытые файлы скрыты |
| `list-view.default-zoom-level` | `small` | Компактные строки |
| `sidebar-width` | `200` | Ширина боковой панели |

## GTK CSS

Стили добавляются в `~/.config/gtk-4.0/gtk.css`.  
Блок обрамлён комментариями для удобного удаления:

```css
/* ===== Nautilus macOS Finder style ===== */
...
/* ===== конец Nautilus стиля ===== */
```

## Контекстное меню

Скрипт сохраняется в `~/.local/share/nautilus/scripts/`.  
Вызов: правый клик → **Скрипты** → **Открыть в терминале**.  
Поддерживает Ptyxis и GNOME Terminal автоматически.

## Ключевые пути

| Путь | Содержимое |
|------|------------|
| `~/.config/gtk-4.0/gtk.css` | GTK CSS стили |
| `~/.local/share/nautilus/scripts/` | Скрипты контекстного меню |
| `~/nautilus-setup.log` | Лог выполнения |

## Откат

```bash
# Сбросить настройки Nautilus
gsettings reset-recursively org.gnome.nautilus.preferences
gsettings reset-recursively org.gnome.nautilus.list-view
gsettings reset-recursively org.gnome.nautilus.window-state

# Удалить CSS — вручную удалить блок между комментариями
nano ~/.config/gtk-4.0/gtk.css

# Удалить скрипт контекстного меню
rm ~/.local/share/nautilus/scripts/Открыть\ в\ терминале
```
