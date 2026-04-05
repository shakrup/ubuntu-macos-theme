#!/bin/bash
set -e

echo "=== 🖥️  Настройка терминала в стиле macOS ==="

# Защита от root
if [ "$EUID" -eq 0 ]; then
    echo "❌ Не запускайте от root!"
    exit 1
fi

LOGFILE=~/terminal-setup.log
exec > >(tee -a "$LOGFILE") 2>&1
echo "📝 Лог: $LOGFILE"
echo "🕐 Начало: $(date)"

# Проверка oh-my-posh
if ! command -v oh-my-posh &>/dev/null; then
    echo "❌ oh-my-posh не найден. Установите его сначала:"
    echo "   curl -s https://ohmyposh.dev/install.sh | bash -s"
    exit 1
fi

# Проверка zsh
if ! command -v zsh &>/dev/null; then
    echo "❌ zsh не найден. Установите: sudo apt install zsh"
    exit 1
fi

# === [1/4] Nerd Font (MesloLGS) ===
echo ""
echo "[1/4] Установка шрифта MesloLGS NF..."
FONT_DIR=~/.local/share/fonts/MesloLGS
mkdir -p "$FONT_DIR"

BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
FONTS=(
    "MesloLGS%20NF%20Regular.ttf"
    "MesloLGS%20NF%20Bold.ttf"
    "MesloLGS%20NF%20Italic.ttf"
    "MesloLGS%20NF%20Bold%20Italic.ttf"
)

ALL_OK=true
for FONT in "${FONTS[@]}"; do
    FILENAME="${FONT//%20/ }"
    DEST="$FONT_DIR/$FILENAME"
    if [ ! -f "$DEST" ]; then
        if curl -fsSL "$BASE_URL/$FONT" -o "$DEST" 2>/dev/null; then
            echo "   ✅ $FILENAME"
        else
            echo "   ⚠️  Не удалось скачать $FILENAME"
            ALL_OK=false
        fi
    else
        echo "   ⏭️  $FILENAME уже установлен"
    fi
done

if $ALL_OK; then
    fc-cache -f -v > /dev/null 2>&1
    echo "✅ Шрифты установлены, кэш обновлён"
else
    echo "⚠️  Некоторые шрифты не установлены — иконки могут отображаться некорректно"
fi

# === [2/4] Тема oh-my-posh ===
echo ""
echo "[2/4] Создание темы macOS..."
THEME_DIR=~/.config/oh-my-posh
mkdir -p "$THEME_DIR"
THEME_FILE="$THEME_DIR/macos.omp.json"

cat > "$THEME_FILE" << 'EOF'
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "version": 2,
  "final_space": true,
  "blocks": [
    {
      "type": "prompt",
      "alignment": "left",
      "segments": [
        {
          "type": "os",
          "style": "plain",
          "foreground": "#6E9FE0",
          "template": "\uf179 "
        },
        {
          "type": "path",
          "style": "plain",
          "foreground": "#C5C8C6",
          "properties": {
            "style": "agnoster_short",
            "max_depth": 3,
            "folder_separator_icon": " \uE0B1 "
          },
          "template": "{{ .Path }}"
        },
        {
          "type": "git",
          "style": "plain",
          "foreground": "#A8CC8C",
          "foreground_templates": [
            "{{ if .Working.Changed }}#F0C27F{{ end }}",
            "{{ if .Staging.Changed }}#E06C75{{ end }}"
          ],
          "properties": {
            "fetch_status": true,
            "branch_icon": " \uE0A0 "
          },
          "template": "{{ .BranchIcon }}{{ .HEAD }}{{ if .Working.Changed }} \u00b1{{ end }}{{ if .Staging.Changed }} \u25cf{{ end }}"
        },
        {
          "type": "node",
          "style": "plain",
          "foreground": "#6EBF87",
          "template": "  {{ .Full }}",
          "properties": {
            "display_mode": "files"
          }
        },
        {
          "type": "python",
          "style": "plain",
          "foreground": "#6EBF87",
          "template": "  {{ .Full }}",
          "properties": {
            "display_mode": "files"
          }
        }
      ]
    },
    {
      "type": "prompt",
      "alignment": "left",
      "newline": true,
      "segments": [
        {
          "type": "exit",
          "style": "plain",
          "foreground": "#A8CC8C",
          "foreground_templates": [
            "{{ if gt .Code 0 }}#E06C75{{ end }}"
          ],
          "template": "\u276f "
        }
      ]
    }
  ]
}
EOF
echo "✅ Тема сохранена: $THEME_FILE"

# === [3/4] Обновление .zshrc ===
echo ""
echo "[3/4] Настройка .zshrc..."

# Backup
cp ~/.zshrc ~/.zshrc.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
echo "   📦 Backup .zshrc создан"

# Удаляем старую строку инициализации oh-my-posh если есть
if grep -q "oh-my-posh init zsh" ~/.zshrc 2>/dev/null; then
    sed -i '/oh-my-posh init zsh/d' ~/.zshrc
    echo "   🗑️  Старая конфигурация oh-my-posh удалена"
fi

# Добавляем новую
cat >> ~/.zshrc << EOF

# oh-my-posh macOS theme
eval "\$(oh-my-posh init zsh --config $THEME_FILE)"
EOF

echo "✅ .zshrc обновлён"

# === [4/4] Определяем терминал и пытаемся поставить шрифт ===
echo ""
echo "[4/4] Настройка шрифта в терминале..."

# Ptyxis (Ubuntu 25.04+)
if command -v ptyxis &>/dev/null || gsettings list-schemas 2>/dev/null | grep -q "org.gnome.Ptyxis$"; then
    echo "   Обнаружен Ptyxis..."
    # Получаем список профилей
    PROFILES=$(gsettings get org.gnome.Ptyxis profile-uuids 2>/dev/null | tr -d "[]' " | tr ',' '\n' || true)
    if [ -n "$PROFILES" ]; then
        DEFAULT_PROFILE=$(echo "$PROFILES" | head -1)
        SCHEMA="org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$DEFAULT_PROFILE/"
        gsettings set "$SCHEMA" use-system-font false 2>/dev/null || true
        gsettings set "$SCHEMA" font-name "MesloLGS NF 13" 2>/dev/null && \
            echo "✅ Шрифт MesloLGS NF 13 установлен в Ptyxis" || \
            echo "⚠️  Не удалось установить шрифт в Ptyxis автоматически"
    else
        echo "⚠️  Профили Ptyxis не найдены"
    fi
# GNOME Terminal
elif command -v gnome-terminal &>/dev/null; then
    echo "   Обнаружен GNOME Terminal..."
    PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null | tr -d "'")
    if [ -n "$PROFILE" ]; then
        SCHEMA="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/"
        gsettings set "$SCHEMA" use-system-font false 2>/dev/null || true
        gsettings set "$SCHEMA" font "MesloLGS NF 13" 2>/dev/null && \
            echo "✅ Шрифт MesloLGS NF 13 установлен в GNOME Terminal" || \
            echo "⚠️  Не удалось установить шрифт автоматически"
    fi
else
    echo "⚠️  Терминал не определён — установите шрифт вручную (см. инструкцию ниже)"
fi

# === Итог ===
echo ""
echo "✅ ==============================="
echo "✅  Терминал настроен!"
echo "✅ ==============================="
echo ""
echo "📋 Что сделано:"
echo "   • Шрифт MesloLGS NF установлен в ~/.local/share/fonts/"
echo "   • Тема oh-my-posh: $THEME_FILE"
echo "   • .zshrc обновлён"
echo ""
echo "🔤 Если шрифт в терминале не применился автоматически:"
echo "   Ptyxis:        Настройки → Профиль → Шрифт → MesloLGS NF 13"
echo "   GNOME Terminal: Правка → Параметры профиля → Текст → Шрифт → MesloLGS NF 13"
echo ""
echo "🔄 Применить тему без перезапуска:"
echo "   source ~/.zshrc"
echo ""
echo "🎨 Сменить тему позже:"
echo "   oh-my-posh get shell themes   # посмотреть все темы"
echo "   oh-my-posh init zsh --config ~/.config/oh-my-posh/macos.omp.json"
