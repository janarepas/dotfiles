"""Shared browser preferences; local permissions and state stay outside Git."""
import importlib.util
import shlex
import shutil
import sys
from pathlib import Path

config.load_autoconfig()

c.auto_save.session = True
c.session.lazy_restore = True
c.content.autoplay = False
c.scrolling.smooth = True

c.content.blocking.enabled = True
# Linux installations may omit the optional Rust adblock module.
c.content.blocking.method = "both" if importlib.util.find_spec("adblock") else "hosts"
c.content.javascript.clipboard = "ask"

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "gh": "https://github.com/search?o=desc&q={}&s=stars",
    "yt": "https://www.youtube.com/results?search_query={}",
}

config.bind(",g", "cmd-set-text -s :open gh")
config.bind(",y", "cmd-set-text -s :open yt")

if sys.platform == "darwin":
    config.bind(",p", "spawn /usr/bin/open -a Passwords")

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
