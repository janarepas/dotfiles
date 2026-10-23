# Dotfiles

Minimal Vim-, Neovim-, tmux- és Ghostty-konfiguráció macOS és Linux rendszerekhez.
Az Alacritty-konfiguráció eltávolítása szándékos. Shell-, PATH-, locale- és
Linux-rendszerbeállításokat ez a repó nem kezel.

## Követelmények

- Neovim 0.12+ a teljes konfigurációhoz és a beépített `vim.pack` telepítőhöz.
- Vim 8.2+; a tartós undo csak az azt támogató buildben kapcsol be.
- tmux 3.2+; `infocmp` és a `screen-256color` vagy `tmux-256color` terminfo.
- Git a klónozáshoz és a Neovim-téma telepítéséhez.
- UTF-8 locale és 256 színt támogató terminál. Nerd Font nem szükséges.

Debian/Ubuntu alatt a rendszer csomagkezelőjéből telepíthető a `git`, `vim`,
`tmux`, `ncurses-bin`, `ncurses-term`; a Neovim verzióját külön ellenőrizd,
mert a disztribúció csomagja lehet régebbi. macOS alatt például Homebrew-val
telepíthető a Git, Neovim és tmux. Ellenőrzés: `nvim --version`, `vim --version`,
`tmux -V`, `infocmp tmux-256color`.

## Telepítés

Klónozd a repót a kívánt helyre. Az alábbi parancsok a repó gyökeréből futnak.
Előbb nézd meg és mentsd el a már meglévő konfigurációkat/szimbolikus linkeket.
A parancsok nem használnak kényszerített felülírást; csak még nem létező
célokra készíts linket.

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
# Meglévő cél esetén kihagyás: könyvtáron belül sem készül újabb link.
link_if_absent() {
  if [ -e "$2" ] || [ -L "$2" ]; then
    echo "Már létezik, kihagyva: $2"
  else
    ln -s "$1" "$2"
  fi
}
link_if_absent "$PWD/nvim" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
link_if_absent "$PWD/vim/vimrc" "$HOME/.vimrc"
link_if_absent "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"
link_if_absent "$PWD/ghostty" "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
link_if_absent "$PWD/mpv" "${XDG_CONFIG_HOME:-$HOME/.config}/mpv"
link_if_absent "$PWD/openlogi" "${XDG_CONFIG_HOME:-$HOME/.config}/openlogi"
link_if_absent "$PWD/qutebrowser" "${XDG_CONFIG_HOME:-$HOME/.config}/qutebrowser"
if [ "$(uname -s)" = Darwin ]; then
  mkdir -p "$HOME/.qutebrowser"
  link_if_absent "$PWD/qutebrowser/config.py" "$HOME/.qutebrowser/config.py"
fi
```

Ha már `~/.config/tmux` linket használsz, megtarthatod azt a `~/.tmux.conf`
helyett; ne telepíts két eltérő tmux-konfigurációt. A linkek abszolútak:
a klón áthelyezésekor újra létre kell hozni őket.

## Ghostty

A `~/.config/ghostty` (vagy `$XDG_CONFIG_HOME/ghostty`) a repó teljes `ghostty`
könyvtárára mutasson; külön `config` fájllinkre nincs szükség. A Ghostty
alkalmazást külön kell telepíteni. A konfiguráció ablakméretet, betűméretet,
belső margót és áttetszőséget állít be; az elmosás platform- és
ablakkezelőfüggő. Újratöltéshez használd a Ghostty Reload Configuration menüjét.

## Neovim: offline indulás és téma

A szerkesztő bővítmény nélkül is elindul. Induláskor nincs hálózati letöltés,
a telepített témát a natív `packadd` tölti be. A belső, nem publikus UI-modulra
nincs függőség.

A téma első telepítését Neovimben indítsd:

```vim
:DotfilesInstallPlugins
```

Ehhez Git és GitHub-elérés szükséges. Csak a TokyoNight témát használjuk;
a Treesitter, LSP és kiegészítő bővítmények nem részei ennek a konfigurációnak.
A forráskódban rögzített commit és a `nvim/nvim-pack-lock.json` együtt biztosítja
az új telepítés verzióját. A lockfájlt is commitold. Meglévő telepítés verzióját
az `add` nem állítja át automatikusan.

Frissítéskor változtasd meg a `pack.lua` rögzített commitját, futtasd a
`:DotfilesInstallPlugins` parancsot, majd a
`:lua vim.pack.update({ 'tokyonight.nvim' })` parancsot. Nézd át és hagyd jóvá
a változásokat a megjelenő ablakban, majd commitold a frissített lockfájlt.
A bővítmények a felhasználó jogosultságaival futó kódot tartalmaznak.

## Vágólap és terminál

A Neovim a rendszer vágólapját használja, ha van szolgáltató; ennek hiányában
a hagyományos belső regiszterek maradnak aktívak:
macOS-on `pbcopy`/`pbpaste`, Linux Waylanden `wl-copy`/`wl-paste` (`wl-clipboard`),
X11-en `xclip` vagy `xsel`. Távoli vagy kijelző nélküli gépen a rendszer-vágólap
külön beállítást igényelhet. Diagnosztika: `:checkhealth vim.provider`.

A tmux belül `tmux-256color` értéket használ, ha elérhető; egyébként
`screen-256color` értékre esik vissza. SSH célgépen is szükséges a megfelelő
terminfo. Ellenőrizd a `TERM` értékét tmuxon belül és kívül. Az RGB támogatás
az adott külső termináltól függ; csak annak megfelelő `terminal-features`
beállítást adj hozzá.

## Közös szerkesztési beállítások

Két szóköz, tab helyett szóközök, sortördelés nélkül, relatív sorszámok,
intelligens kis-/nagybetűs keresés. Leader: szóköz.

| Billentyű | Művelet |
| --- | --- |
| `<leader>w` | Mentés |
| `<leader>q` | Ablak bezárása |
| `<leader>e` | Fájlböngésző |
| `<leader>h` | Kereséskiemelés törlése |
| `jk` vagy `jj` beszúráskor | Normál mód |

Az undo és swap helyreállítást segít; érzékeny tartalom is megmaradhat bennük.
Az új undo-könyvtárak 0700 jogosultsággal készülnek. Meglévő könyvtárak
jogosultságát külön ellenőrizd. A swap engedélyezett, külön backup nincs.


## Érzékeny fájlok

Vimben és Neovimben automatikusan kikapcsol a swap, a tartós undo és a
modeline a következő fájloknál: `.env`, `.env.*`, `*.pem`, `*.key`, `*.p12`,
`*.pfx`, SSH-kulcsok és a `.ssh`/`.gnupg` alatti fájlok, `.netrc`, `.authinfo`,
AWS credentials, kubeconfig az alapértelmezett helyén, Docker config,
`.npmrc`, `.pypirc`, `.git-credentials`. A fájlnév és a feloldott szimbolikus
link célja is számít. Az ideiglenes írási backupokra is vonatkozik a kizárás.
A már érzékenynek jelölt buffer átnevezés után is védett marad.

Más nevű érzékeny fájlnál szerkesztés előtt: `:setlocal noswapfile noundofile nomodeline`.
Ez név alapú védelem; nem vizsgálja a tartalmat, és nem törli a korábban
létrejött undo/swap fájlokat. A regiszterek, parancselőzmények, a rendszer
vágólapja és a fájlrendszer korábbi másolatai külön kezelendők. Már nyitott
fájloknál indítsd újra a szerkesztőt a változás után.

## Környezetellenőrzés

A repó gyökeréből futtasd: `sh scripts/check-environment.sh`.
Az ellenőrzés macOS-on és Linuxon is futtatható; nem telepít csomagokat és
nem módosít konfigurációt. Külön jelzi a vágólap hiányzó szolgáltatóját,
a terminfo-bejegyzéseket és az elérhető Ghostty konfigurációellenőrzését.
SSH célgépen is futtasd; a színek, billentyűk, vágólap és elmosás tényleges
működését a célgépen kell ellenőrizni.


## mpv és OpenLogi

A `~/.config/mpv` és `~/.config/openlogi` (vagy az XDG_CONFIG_HOME alatti
megfelelő könyvtárak) a repó `mpv` és `openlogi` könyvtáraira mutatnak.
Az alkalmazásokat külön kell telepíteni. A Git csak az `mpv/mpv.conf` és
az `openlogi/config.toml` fájlokat követi; a lejátszási állapot, socketek,
lockfájlok és az alkalmazás által készített mentések helyben maradnak.
Az OpenLogi konfiguráció eszközazonosítókat és eszközönkénti beállításokat
tartalmaz; más gépen/eszközzel ezeket az alkalmazásban kell hozzáigazítani.


## qutebrowser

Csak a `qutebrowser/config.py` verziókövetett. Linuxon a konfigurációs könyvtár
az XDG_CONFIG_HOME alatti `qutebrowser` mappa. macOS-on a
`~/.qutebrowser/config.py` is erre a fájlra mutasson; a többi böngészőadatot
ne helyezd a repóba. Az `autoconfig.yml` helyi marad és induláskor betöltődik;
a közös `config.py` beállításai utána elsőbbséget kapnak. Webhelyenkénti
engedélyek, könyvjelzők, előzmények és munkamenetek nem kerülnek Gitbe.

- `,g`: GitHub-keresés relevancia szerint; `,y`: YouTube-keresés.
- Kilépéskor figyelmeztet, ha még folyamatban van letöltés.
- `,v`: az aktuális cím átadása mpv-nek, ha az mpv elérhető. macOS-on a
  Homebrew szokásos telepítési helyeit is ellenőrzi, mert a Finderből
  indított app PATH-ja eltérhet a terminálétól.
- `,p`: Passwords megnyitása, csak macOS-on, az alkalmazás teljes útvonalával.
- `⌘T`: új lap, normál és beviteli módban is, macOS-on a `Ctrl+T` helyett.
- A sima görgetés és a lusta munkamenet-visszaállítás bekapcsolva, az
  automatikus médialejátszás kikapcsolva marad.
- Reklámblokkolás: `both`, ha az opcionális `adblock` modul telepítve van,
  különben `hosts`. Listák frissítése a böngészőben: `:adblock-update`.
- Új webhelyek JavaScript-vágólapengedélye `ask`; a helyileg külön
  engedélyezett webhelyek ezt felülírhatják. Ezeket a böngészőben lehet
  visszaállítani: `:config-unset -u https://example.org content.javascript.clipboard`.

Újratöltés a böngészőben: `:config-source`.
