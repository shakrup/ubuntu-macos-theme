# terminal-macos.sh

Настройка терминала: oh-my-posh + zsh + MesloLGS NF.

## Требования

- `oh-my-posh` установлен и доступен в PATH
- `zsh` установлен и используется как shell

## Что делает

1. Проверяет наличие oh-my-posh и zsh
2. Скачивает MesloLGS NF в `~/.local/share/fonts/MesloLGS/`
3. Создаёт тему `~/.config/oh-my-posh/macos.omp.json`
4. Добавляет инициализацию в `~/.zshrc`
5. Устанавливает шрифт в Ptyxis или GNOME Terminal через gsettings

## Промпт

```
 ~/Projects ❯ branch-name  main ±
❯
```

Первая строка: иконка ОС · путь · git ветка · статус изменений  
Вторая строка: `❯` (зелёный / красный при ошибке)

## Цвета

| Элемент | Цвет |
|---------|------|
| Иконка Apple | `#6E9FE0` |
| Путь | `#C5C8C6` |
| Git чистый | `#A8CC8C` |
| Git working changes | `#F0C27F` |
| Git staged changes | `#E06C75` |
| Node / Python версия | `#6EBF87` |

## Ключевые пути

| Путь | Содержимое |
|------|------------|
| `~/.config/oh-my-posh/macos.omp.json` | Тема oh-my-posh |
| `~/.local/share/fonts/MesloLGS/` | Шрифт MesloLGS NF |
| `~/.zshrc.bak.*` | Backup .zshrc |
| `~/terminal-setup.log` | Лог выполнения |

## Откат

```bash
# Восстановить .zshrc (выбрать нужный backup)
cp ~/.zshrc.bak.YYYYMMDD_HHMMSS ~/.zshrc

# Или вручную удалить строку из .zshrc:
# eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/macos.omp.json)"
```
