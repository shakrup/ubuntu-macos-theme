#!/bin/bash
set -e

echo "=== 🧩 macOS кастомизация Ubuntu 25.10 ==="

# Защита от запуска от root
if [ "$EUID" -eq 0 ]; then
    echo "❌ Не запускайте скрипт от root — gsettings работает только от пользователя!"
    exit 1
fi

# Лог-файл
LOGFILE=~/macos-setup.log
exec > >(tee -a "$LOGFILE") 2>&1
echo "📝 Лог записывается в $LOGFILE"
echo "🕐 Начало: $(date)"

# Дата один раз — используется в backup
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=~/backup_themes_$BACKUP_DATE
WORK_DIR=~/macos-setup

# Очистка от предыдущих запусков
echo "🧹 Очистка временных файлов от предыдущих запусков..."
rm -rf "$WORK_DIR" 2>/dev/null || true

# Функция для проверки доступности URL
check_url() {
    curl --silent --head --fail "$1" > /dev/null 2>&1
}

# === [1/10] Зависимости ===
echo ""
echo "[1/10] Обновление и установка зависимостей..."
sudo apt update && sudo apt install -y \
    git curl wget \
    gnome-tweaks \
    gnome-shell-extensions \
    gnome-shell-extension-manager \
    gnome-browser-connector \
    unzip \
    libglib2.0-dev-bin \
    sassc \
    make \
    build-essential \
    gettext
echo "✅ Зависимости установлены"

# === [2/10] Backup и очистка тем ===
echo ""
echo "[2/10] Backup и очистка пользовательских тем..."
if [ -d ~/.themes ] || [ -d ~/.icons ]; then
    mkdir -p "$BACKUP_DIR"
    [ -d ~/.themes ] && cp -r ~/.themes "$BACKUP_DIR/" || true
    [ -d ~/.icons ]  && cp -r ~/.icons  "$BACKUP_DIR/" || true
    echo "📦 Backup сохранён в $BACKUP_DIR"
fi
rm -rf ~/.themes ~/.icons
sudo apt install --reinstall -y yaru-theme-gtk yaru-theme-icon 2>/dev/null || \
    echo "⚠️  Пакеты yaru-theme не найдены, пропускаем"
echo "✅ Очистка завершена"

# === [3/10] Темы, иконки, курсоры WhiteSur ===
echo ""
echo "[3/10] Установка WhiteSur темы, иконок и курсоров..."
mkdir -p "$WORK_DIR" && cd "$WORK_DIR"

echo "📦 Клонирование репозиториев WhiteSur..."
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-cursors.git

(cd "$WORK_DIR/WhiteSur-gtk-theme"  && ./install.sh -c dark -t default -N mojave)
(cd "$WORK_DIR/WhiteSur-icon-theme" && ./install.sh -a)
(cd "$WORK_DIR/WhiteSur-cursors"    && ./install.sh)
echo "✅ Темы WhiteSur установлены"

# === [4/10] Шрифты San Francisco ===
echo ""
echo "[4/10] Установка шрифтов San Francisco..."
cd "$WORK_DIR"
git clone --depth=1 https://github.com/supermarin/YosemiteSanFranciscoFont.git
mkdir -p ~/.fonts

if compgen -G "$WORK_DIR/YosemiteSanFranciscoFont/*.ttf" > /dev/null 2>&1; then
    cp "$WORK_DIR/YosemiteSanFranciscoFont/"*.ttf ~/.fonts/
    fc-cache -f -v
    echo "✅ Шрифты San Francisco установлены"
else
    echo "⚠️  Шрифты TTF не найдены, пропускаем"
fi

# === [5/10] Экран входа ===
echo ""
echo "[5/10] Пропуск настройки экрана входа..."
echo "⚠️  Настройка GDM пропущена — при необходимости настройте вручную через GNOME Tweaks"

# === [6/10] Обои ===
echo ""
echo "[6/10] Установка обоев macOS Catalina..."
mkdir -p ~/Pictures
WALLPAPER_URL="https://raw.githubusercontent.com/linuxdotexe/macOS-Catalina-Wallpaper/master/macos-catalina.jpg"

if check_url "$WALLPAPER_URL"; then
    wget -q -O ~/Pictures/macos-wallpaper.jpg "$WALLPAPER_URL"
    gsettings set org.gnome.desktop.background picture-uri \
        "file://$HOME/Pictures/macos-wallpaper.jpg"
    gsettings set org.gnome.desktop.background picture-uri-dark \
        "file://$HOME/Pictures/macos-wallpaper.jpg"
    gsettings set org.gnome.desktop.background picture-options "zoom"
    echo "✅ Обои установлены"
else
    echo "⚠️  Не удалось загрузить обои, оставляем стандартные"
fi

# === [7/10] GNOME расширения ===
echo ""
echo "[7/10] Установка расширений GNOME..."
mkdir -p ~/.local/share/gnome-shell/extensions

# Blur My Shell — сборка из исходников
if git ls-remote --exit-code https://github.com/aunetx/blur-my-shell.git &>/dev/null; then
    cd "$WORK_DIR"
    git clone --depth=1 https://github.com/aunetx/blur-my-shell.git

    if command -v make &>/dev/null && command -v msgfmt &>/dev/null; then
        echo "🔨 Сборка Blur My Shell..."
        (cd "$WORK_DIR/blur-my-shell" && make install)
        echo "✅ Blur My Shell установлен"
    else
        echo "⚠️  Отсутствуют инструменты сборки, пропускаем Blur My Shell"
        echo "💡 Установите вручную: https://extensions.gnome.org/extension/3193/blur-my-shell/"
    fi
else
    echo "⚠️  Репозиторий Blur My Shell недоступен"
fi

# Встроенные расширения Ubuntu
gnome-extensions enable ubuntu-appindicators@ubuntu.com 2>/dev/null || \
    echo "⚠️  ubuntu-appindicators не найден"
gnome-extensions enable ubuntu-dock@ubuntu.com 2>/dev/null || \
    echo "⚠️  ubuntu-dock не найден"

# === [8/10] Системные звуки ===
echo ""
echo "[8/10] Установка системных звуков macOS..."
SOUNDS_DIR=~/.local/share/sounds/macOS
mkdir -p "$SOUNDS_DIR"
SOUNDS_URL="https://github.com/B00merang-Project/macOS-sounds/archive/refs/heads/master.zip"

if check_url "$SOUNDS_URL"; then
    wget -q "$SOUNDS_URL" -O /tmp/macos-sounds.zip
    unzip -q /tmp/macos-sounds.zip -d /tmp/macos-sounds/
    cp -r /tmp/macos-sounds/macOS-sounds-master/. "$SOUNDS_DIR/"
    rm -rf /tmp/macos-sounds.zip /tmp/macos-sounds/
    gsettings set org.gnome.desktop.sound theme-name "macOS" 2>/dev/null || \
        echo "⚠️  Не удалось применить звуковую тему"
    echo "✅ Звуки установлены"
else
    echo "⚠️  Не удалось загрузить звуки macOS"
fi

# === [9/10] Применение тем и шрифтов ===
echo ""
echo "[9/10] Применение тем и шрифтов..."

gsettings set org.gnome.desktop.interface gtk-theme        "WhiteSur-Dark"    2>/dev/null || \
    echo "⚠️  Тема WhiteSur-Dark не найдена"
gsettings set org.gnome.desktop.wm.preferences theme       "WhiteSur-Dark"    2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme       "WhiteSur"         2>/dev/null || \
    echo "⚠️  Иконки WhiteSur не найдены"
gsettings set org.gnome.desktop.interface cursor-theme     "WhiteSur-cursors" 2>/dev/null || \
    echo "⚠️  Курсоры WhiteSur не найдены"

# Шрифты с fallback на системные
gsettings set org.gnome.desktop.interface font-name \
    "San Francisco Display 11" 2>/dev/null || \
    gsettings set org.gnome.desktop.interface font-name "Ubuntu 11"

gsettings set org.gnome.desktop.interface document-font-name \
    "San Francisco Text 11" 2>/dev/null || \
    gsettings set org.gnome.desktop.interface document-font-name "Ubuntu 11"

gsettings set org.gnome.desktop.interface monospace-font-name \
    "SF Mono 12" 2>/dev/null || \
    gsettings set org.gnome.desktop.interface monospace-font-name "Ubuntu Mono 13"

gsettings set org.gnome.desktop.wm.preferences titlebar-font \
    "San Francisco Display Bold 11" 2>/dev/null || \
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "Ubuntu Bold 11"

echo "✅ Темы и шрифты применены"

# === [10/10] Настройка дока ===
echo ""
echo "[10/10] Конфигурация дока..."
if gsettings list-schemas | grep -q "org.gnome.shell.extensions.dash-to-dock"; then
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position      'BOTTOM'
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height      false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed         true
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode  'FIXED'
    gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.35
    gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top   false
    gsettings set org.gnome.shell.extensions.dash-to-dock intellihide        false
    echo "✅ Dok настроен"
else
    echo "⚠️  Расширение dash-to-dock не найдено"
    echo "💡 Установите вручную: https://extensions.gnome.org/extension/307/dash-to-dock/"
fi

# === Очистка ===
echo ""
echo "🧹 Очистка временных файлов..."
rm -rf "$WORK_DIR" 2>/dev/null || true

# === Итог ===
echo ""
echo "✅ ==============================="
echo "✅  Кастомизация завершена!"
echo "✅ ==============================="
echo ""
echo "📋 Что сделано:"
echo "   • Темы, иконки и курсоры WhiteSur"
echo "   • Шрифты San Francisco"
echo "   • Обои macOS Catalina"
echo "   • Расширения GNOME (Blur My Shell)"
echo "   • Системные звуки macOS"
echo "   • Настройка дока"
echo ""
echo "📝 Полный лог: $LOGFILE"
[ -d "$BACKUP_DIR" ] && echo "📦 Backup старых тем: $BACKUP_DIR"
echo ""
echo "🔄 Перезагрузите систему или выйдите из сессии"
echo "⚙️  Дополнительные настройки — в GNOME Tweaks"
