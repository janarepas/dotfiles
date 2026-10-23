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

A Neovim a rendszer vágólapját használja, ha van szolgáltató:
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
