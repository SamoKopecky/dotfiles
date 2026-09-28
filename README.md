# dotfiles

My dotfiles for bash, tmux and neovim

Managed by [yadm](https://yadm.io/)

## How to install

Run

```shell
yadm clone https://github.com/SamoKopecky/dotfiles.git
```

`yadm bootstrap` installs packages from `~/.config/pacman/pkglist.txt` (Arch
only), tmux plugins, konsave profile and rustup.

## Neovim dependencies

Neovim **0.12+** is required (nvim-treesitter `main` branch).

Plugins, LSP servers and formatters install themselves on first start (lazy.nvim
and Mason), but they need these tools on the system first.

### Arch one-liner

```shell
sudo pacman -S --needed neovim tree-sitter-cli base-devel git curl wget unzip \
  tar gzip ripgrep fd python python-pip go ruby wl-clipboard
```

Node comes from [nvm](https://github.com/nvm-sh/nvm), Rust from rustup
(bootstrap installs it).

### What needs what

| Tool                     | Needed by                                                                 |
| ------------------------ | ------------------------------------------------------------------------- |
| `tree-sitter` CLI        | nvim-treesitter `main` compiles parsers with it. **Easy to forget.**      |
| C compiler, `make`       | treesitter parsers, telescope-fzf-native, LuaSnip (`base-devel`)          |
| `git`                    | lazy.nvim, Mason                                                          |
| `curl`/`wget`, `unzip`, `tar`, `gzip` | Mason downloads; codediff.nvim fetches its diff library      |
| `ripgrep`                | telescope live grep, nvim-spectre                                         |
| `fd`                     | telescope file finder                                                     |
| `node` + `npm`           | Mason: ts_ls, vue_ls, eslint, cssls, prettier, eslint_d, markdownlint, sql-formatter |
| `python` + `pip`         | Mason: basedpyright                                                       |
| `go`                     | Mason: gopls                                                              |
| `ruby` + `gem`           | Mason: ruby_lsp                                                           |
| `cargo` (rustup)         | rust toolchain for rust_analyzer projects                                 |
| `wl-clipboard`           | system clipboard on Wayland (`xclip` on X11)                              |
| Nerd Font                | icons in neo-tree, lualine, codediff explorer                             |

LSP servers and tools Mason installs are listed in
`~/.config/nvim/lua/plugins/lsp/packages_lsp.lua` and
`~/.config/nvim/lua/plugins/lsp/packages.lua`.

### Checking a new machine

Inside nvim:

```vim
:checkhealth
:Mason
:Lazy
```

`:CodeDiff install` re-downloads codediff's diff library if the auto download
failed.
