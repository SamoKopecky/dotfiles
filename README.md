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

Requires Neovim 0.12 or newer, for the nvim-treesitter `main` branch.

lazy.nvim and Mason install plugins, LSP servers and formatters on first
start. They need these system packages:

```shell
sudo pacman -S --needed neovim tree-sitter-cli base-devel git curl wget unzip \
  tar gzip ripgrep fd python python-pip go ruby wl-clipboard
```

Node is installed with [nvm](https://github.com/nvm-sh/nvm), Rust with rustup
(`yadm bootstrap` runs it).

| Tool                                  | Used by                                                          |
| ------------------------------------- | ---------------------------------------------------------------- |
| `tree-sitter` CLI                     | nvim-treesitter, to compile parsers                              |
| C compiler, `make`                    | treesitter parsers, telescope-fzf-native, LuaSnip                |
| `git`                                 | lazy.nvim, Mason                                                 |
| `curl` or `wget`, `unzip`, `tar`, `gzip` | Mason; codediff.nvim, to download its diff library            |
| `ripgrep`                             | telescope live grep, nvim-spectre                                |
| `fd`                                  | telescope file search                                            |
| `node`, `npm`                         | Mason: ts_ls, vue_ls, eslint, cssls, prettier, eslint_d, markdownlint, sql-formatter |
| `python`, `pip`                       | Mason: basedpyright                                              |
| `go`                                  | Mason: gopls                                                     |
| `ruby`, `gem`                         | Mason: ruby_lsp                                                  |
| `cargo`                               | Rust projects edited with rust_analyzer                          |
| `wl-clipboard`                        | system clipboard on Wayland; `xclip` on X11                      |
| Nerd Font                             | icons in neo-tree, lualine, codediff                             |

Mason packages are listed in `~/.config/nvim/lua/plugins/lsp/packages_lsp.lua`
(LSP servers) and `~/.config/nvim/lua/plugins/lsp/packages.lua` (other tools).

To check a new install, run `:checkhealth`, `:Mason` and `:Lazy`. If the
codediff library download failed, run `:CodeDiff install`.
