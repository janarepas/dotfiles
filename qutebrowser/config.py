"""Shared browser preferences; local permissions and state stay outside Git."""
import importlib.util
import shlex
import shutil
import sys
from pathlib import Path

config.load_autoconfig()

c.auto_save.session = True
c.session.lazy_restore = True
c.confirm_quit = ["downloads"]
c.content.autoplay = False
c.scrolling.smooth = True

c.content.blocking.enabled = True
# Linux installations may omit the optional Rust adblock module.
c.content.blocking.method = "both" if importlib.util.find_spec("adblock") else "hosts"
c.content.javascript.clipboard = "ask"

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "gh": "https://github.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
}

config.bind(",g", "cmd-set-text -s :open gh")
config.bind(",y", "cmd-set-text -s :open yt")

if sys.platform == "darwin":
    config.bind(",p", "spawn /usr/bin/open -a /System/Applications/Passwords.app")
    # Familiar macOS browser shortcuts, on pages and inside input fields.
    mac_bindings = {
        "<Meta-t>": "open -t",
        "<Meta-w>": "tab-close",
        "<Meta-Shift-t>": "undo",
        "<Meta-n>": "open -w",
        "<Meta-Shift-n>": "open -p",
        "<Meta-Shift-w>": "close",
        "<Meta-q>": "quit",
        "<Meta-l>": "cmd-set-text :open {url:pretty}",
        "<Meta-r>": "reload",
        "<Meta-Shift-r>": "reload -f",
        "<Meta-f>": "cmd-set-text /",
        "<Meta-g>": "search-next",
        "<Meta-Shift-g>": "search-prev",
        "<Meta-[>": "back",
        "<Meta-]>": "forward",
        "<Meta-Alt-Left>": "tab-prev",
        "<Meta-Alt-Right>": "tab-next",
        "<Meta-+>": "zoom-in",
        "<Meta-=>": "zoom-in",
        "<Meta-->": "zoom-out",
        "<Meta-0>": "zoom",
    }
    mac_bindings.update({f"<Meta-{number}>": f"tab-focus {number}" for number in range(1, 9)})
    mac_bindings["<Meta-9>"] = "tab-focus -1"
    for key, command in mac_bindings.items():
        for mode in ("normal", "insert"):
            config.bind(key, command, mode=mode)
    config.unbind("<Ctrl-t>", mode="normal")
    config.unbind("<Ctrl-w>", mode="normal")

# Finder-launched macOS apps may not inherit Homebrew's PATH.
mpv = shutil.which("mpv")
if mpv is None and sys.platform == "darwin":
    mpv = next(
        (str(path) for path in (Path("/opt/homebrew/bin/mpv"), Path("/usr/local/bin/mpv"))
         if path.is_file()),
        None,
    )
if mpv:
    config.bind(",v", "spawn " + shlex.quote(mpv) + " {url}")
