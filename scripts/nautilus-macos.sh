#!/bin/bash
set -e

echo "=== 🗂️  Настройка Nautilus в стиле macOS Finder ==="

if [ "$EUID" -eq 0 ]; then
    echo "❌ Не запускайте от root!"
    exit 1
fi

LOGFILE=~/nautilus-setup.log
exec > >(tee -a "$LOGFILE") 2>&1
echo "📝 Лог: $LOGFILE"
echo "🕐 Начало: $(date)"

# === [1/5] Зависимости ===
echo ""
echo "[1/5] Установка зависимостей..."
sudo apt update && sudo apt install -y \
    nautilus \
    nautilus-admin \
    python3-nautilus
echo "✅ Зависимости установлены"

# === [2/5] Настройки Nautilus через gsettings ===
echo ""
echo "[2/5] Применение настроек Nautilus..."

# Вид по умолчанию — список (как в Finder)
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

# Сортировка: папки первыми, по имени
gsettings set org.gnome.nautilus.preferences sort-directories-first true
gsettings set org.gnome.nautilus.preferences default-sort-order 'name'
gsettings set org.gnome.nautilus.preferences default-sort-in-reverse-order false

# Строка пути внизу (как в Finder)
gsettings set org.gnome.nautilus.preferences always-use-location-entry false

# Одиночный клик для открытия (опционально — закомментируйте если не нужно)
# gsettings set org.gnome.nautilus.preferences click-policy 'single'

# Скрытые файлы — не показывать по умолчанию
gsettings set org.gnome.nautilus.preferences show-hidden-files false

# Размер иконок в сетке (как в Finder — средние)
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'medium'

# Размер строк в списке — компактный
gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'

# Колонки в списке (как в Finder: имя, размер, тип, дата)
gsettings set org.gnome.nautilus.list-view default-visible-columns \
    "['name', 'size', 'type', 'date_modified']"
gsettings set org.gnome.nautilus.list-view default-column-order \
    "['name', 'size', 'type', 'date_modified']"

# Строка состояния
gsettings set org.gnome.nautilus.window-state start-with-status-bar true

# Боковая панель
gsettings set org.gnome.nautilus.window-state start-with-sidebar true
gsettings set org.gnome.nautilus.window-state sidebar-width 200

# Открывать новые папки в той же вкладке (поведение Finder)
gsettings set org.gnome.nautilus.preferences open-folder-on-dnd-hover true

# Рекурсивный поиск в подпапках
gsettings set org.gnome.nautilus.preferences recursive-search 'local-only'

# Счётчик элементов в папках в боковой панели
gsettings set org.gnome.nautilus.preferences show-directory-item-counts 'local-only'

echo "✅ Настройки применены"

# === [3/5] GTK CSS — стиль под macOS ===
echo ""
echo "[3/5] Применение кастомного CSS для Nautilus..."
GTK_CSS_DIR=~/.config/gtk-4.0
mkdir -p "$GTK_CSS_DIR"
GTK_CSS="$GTK_CSS_DIR/gtk.css"

# Backup если уже есть
if [ -f "$GTK_CSS" ]; then
    cp "$GTK_CSS" "${GTK_CSS}.bak.$(date +%Y%m%d_%H%M%S)"
    echo "   📦 Backup gtk.css создан"
fi

cat >> "$GTK_CSS" << 'EOF'

/* ===== Nautilus macOS Finder style ===== */

/* Боковая панель — тёмный фон как в Finder */
.nautilus-window .sidebar {
    background-color: #1E2228;
    color: #C5C8C6;
    border-right: 1px solid #2A2D35;
}

/* Элементы боковой панели */
.nautilus-window .sidebar row {
    padding: 4px 8px;
    border-radius: 6px;
    margin: 1px 6px;
    color: #C5C8C6;
    font-size: 13px;
}

/* Активный элемент боковой панели */
.nautilus-window .sidebar row:selected {
    background-color: #3A6BC7;
    color: #FFFFFF;
}

/* Hover на боковой панели */
.nautilus-window .sidebar row:hover:not(:selected) {
    background-color: rgba(255, 255, 255, 0.07);
}

/* Заголовки секций боковой панели (Избранное, Устройства...) */
.nautilus-window .sidebar .sidebar-section-header {
    color: #6B7280;
    font-size: 11px;
    font-weight: bold;
    padding: 10px 14px 2px 14px;
    letter-spacing: 0.5px;
}

/* Основная область — чуть темнее */
.nautilus-window .view {
    background-color: #252830;
    color: #C5C8C6;
}

/* Строки списка */
.nautilus-window .view row {
    padding: 3px 6px;
    border-radius: 4px;
    margin: 1px 4px;
}

/* Выделенный элемент */
.nautilus-window .view row:selected {
    background-color: #3A6BC7;
    color: #FFFFFF;
}

/* Hover на элементе */
.nautilus-window .view row:hover:not(:selected) {
    background-color: rgba(255, 255, 255, 0.05);
}

/* Заголовки колонок */
.nautilus-window .view column-header button {
    background: transparent;
    border: none;
    border-bottom: 1px solid #2A2D35;
    color: #6B7280;
    font-size: 12px;
    padding: 4px 8px;
}

/* Панель инструментов */
.nautilus-window headerbar {
    background-color: #1A1D23;
    border-bottom: 1px solid #2A2D35;
    padding: 4px 8px;
}

/* Кнопки в тулбаре */
.nautilus-window headerbar button {
    background: transparent;
    border: none;
    border-radius: 6px;
    padding: 4px 8px;
    color: #C5C8C6;
}

.nautilus-window headerbar button:hover {
    background-color: rgba(255, 255, 255, 0.1);
}

/* Строка пути (path bar) */
.nautilus-window .path-bar {
    background-color: #1A1D23;
    border-top: 1px solid #2A2D35;
    padding: 2px 8px;
}

.nautilus-window .path-bar button {
    background: transparent;
    border: none;
    color: #6E9FE0;
    font-size: 12px;
    padding: 2px 4px;
    border-radius: 4px;
}

.nautilus-window .path-bar button:hover {
    background-color: rgba(110, 159, 224, 0.15);
}

/* Строка поиска */
.nautilus-window searchbar {
    background-color: #1E2228;
    border-bottom: 1px solid #2A2D35;
}

.nautilus-window searchbar entry {
    background-color: #2A2D35;
    border-radius: 8px;
    border: 1px solid #3A3D45;
    color: #C5C8C6;
    padding: 4px 10px;
}

/* Скроллбар — тонкий как в macOS */
scrollbar {
    background-color: transparent;
    min-width: 6px;
    min-height: 6px;
}

scrollbar slider {
    background-color: rgba(255, 255, 255, 0.2);
    border-radius: 3px;
    min-width: 6px;
    min-height: 20px;
}

scrollbar slider:hover {
    background-color: rgba(255, 255, 255, 0.35);
}

/* ===== конец Nautilus стиля ===== */
EOF

echo "✅ CSS применён: $GTK_CSS"

# === [4/5] Скрипт-расширение: «Открыть в терминале» ===
echo ""
echo "[4/5] Добавление пункта «Открыть в терминале» в контекстное меню..."
SCRIPTS_DIR=~/.local/share/nautilus/scripts
mkdir -p "$SCRIPTS_DIR"

cat > "$SCRIPTS_DIR/Открыть в терминале" << 'SCRIPT'
#!/bin/bash
cd "$NAUTILUS_SCRIPT_CURRENT_URI" 2>/dev/null || \
    cd "$(echo "$NAUTILUS_SCRIPT_CURRENT_URI" | sed 's|file://||')" 2>/dev/null || \
    cd ~
# Ptyxis (Ubuntu 25+)
if command -v ptyxis &>/dev/null; then
    ptyxis &
# GNOME Terminal
elif command -v gnome-terminal &>/dev/null; then
    gnome-terminal &
else
    xterm &
fi
SCRIPT

chmod +x "$SCRIPTS_DIR/Открыть в терминале"
echo "✅ Скрипт добавлен"

# === [5/5] Перезапуск Nautilus ===
echo ""
echo "[5/5] Перезапуск Nautilus..."
nautilus -q 2>/dev/null || true
sleep 1
echo "✅ Nautilus перезапущен"

# === Итог ===
echo ""
echo "✅ ==============================="
echo "✅  Nautilus настроен!"
echo "✅ ==============================="
echo ""
echo "📋 Что сделано:"
echo "   • Вид по умолчанию — список (как в Finder)"
echo "   • Папки первыми, сортировка по имени"
echo "   • Тёмная боковая панель в стиле Finder"
echo "   • Компактные строки, тонкий скроллбар"
echo "   • Колонки: имя, размер, тип, дата"
echo "   • Правый клик → Скрипты → Открыть в терминале"
echo ""
echo "💡 Полезные горячие клавиши (как в Finder):"
echo "   Ctrl+H        — показать/скрыть скрытые файлы"
echo "   Ctrl+L        — перейти по пути"
echo "   Ctrl+F        — поиск"
echo "   Alt+←/→       — назад / вперёд"
echo "   Ctrl+1/2      — переключение вид сетка/список"
echo ""
echo "📝 Лог: $LOGFILE"
echo "🎨 CSS файл: $GTK_CSS"
echo ""
echo "⚠️  Если стили не применились — перезайдите в сессию"
