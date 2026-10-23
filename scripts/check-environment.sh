#!/bin/sh
# Read-only diagnostics; no package installation or configuration changes.
failed=0
for tool in git nvim vim tmux infocmp; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "OK: $tool"
  else
    echo "HIÁNYZIK: $tool"
    failed=1
  fi
done

if command -v nvim >/dev/null 2>&1; then
  if NVIM_LOG_FILE=/dev/null nvim --headless -u NONE -i NONE \
    '+if !has("nvim-0.12") | cquit 1 | endif' +qa; then
    echo 'OK: Neovim 0.12+'
  else
    echo 'HIBA: Neovim 0.12+ szükséges'
    failed=1
  fi
fi

if command -v infocmp >/dev/null 2>&1; then
  terminal_found=0
  for terminal in tmux-256color screen-256color; do
    if infocmp "$terminal" >/dev/null 2>&1; then
      echo "OK: terminfo $terminal"
      terminal_found=1
    else
      echo "FIGYELEM: hiányzó terminfo $terminal"
    fi
  done
  if [ "$terminal_found" -eq 0 ]; then
    echo 'HIBA: egyik tmux termináltípushoz sincs terminfo'
    failed=1
  fi
fi
echo "TERM=${TERM:-nincs}; TMUX=${TMUX:+aktív}"

case "$(uname -s)" in
  Darwin)
    if command -v pbcopy >/dev/null 2>&1 && command -v pbpaste >/dev/null 2>&1; then
      echo 'OK: macOS vágólapparancsok elérhetők'
    else
      echo 'FIGYELEM: pbcopy/pbpaste hiányzik'
    fi
    ;;
  Linux)
    if [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wl-copy >/dev/null 2>&1 && command -v wl-paste >/dev/null 2>&1; then
      echo 'OK: Wayland vágólapparancsok és kijelzőváltozó elérhetők'
    elif [ -n "${DISPLAY:-}" ] && { command -v xclip >/dev/null 2>&1 || command -v xsel >/dev/null 2>&1; }; then
      echo 'OK: X11 vágólapparancs és kijelzőváltozó elérhető'
    else
      echo 'FIGYELEM: nincs észlelt grafikus vágólapszolgáltató; ellenőrizd a :checkhealth vim.provider eredményét'
    fi
    ;;
esac

ghostty_bin=$(command -v ghostty 2>/dev/null || :)
if [ -z "$ghostty_bin" ] && [ -x /Applications/Ghostty.app/Contents/MacOS/ghostty ]; then
  ghostty_bin=/Applications/Ghostty.app/Contents/MacOS/ghostty
fi
if [ -n "$ghostty_bin" ]; then
  if "$ghostty_bin" +validate-config; then
    echo 'OK: Ghostty konfiguráció'
  else
    echo 'HIBA: Ghostty konfiguráció'
    failed=1
  fi
else
  echo 'INFO: Ghostty nincs telepítve vagy nincs a PATH-ban'
fi

exit "$failed"
