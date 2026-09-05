# AGENTS.md

Home Manager dotfiles for user `anon`. Standalone, **channel-based** setup (no flake). Channels: `nixpkgs` = nixos-26.05 (stable), `home-manager` = release-26.05 (stable).

## Commands

- Verify without touching your live profile: `home-manager build` (writes the generation to `/nix/store`).
- Apply: `home-manager switch`.
- Build errors usually mean the Nix eval failed — fix, then `home-manager build` again. `home-manager` is in `~/.nix-profile/bin`, so it only works for the `anon` user.

## The one gotcha that matters

Dotfiles are **not** picked up automatically. `home.nix` only links what is declared in `home.file`:

```nix
".config/fish/config.fish".source = ./config.fish;
".config/nvim".source = ./nvim;
```

Adding a new dotfile/dir requires a new `home.file` entry + rebuild. The live files under `~/.config/...` are read-only symlinks into the nix store — edits there are lost on the next switch. Edit the source tree here, then rebuild.

## Repo layout

- `home.nix` — the only Nix entrypoint. Hardcodes `home.username = "anon"`, `stateVersion = "25.11"`. Do not bump stateVersion; read the comment before touching it.
- `config.fish` — installed as a plain file (not `programs.fish`; its `package` is non-nullable and installing the Nix fish previously broke login config on this box). Contains interactive-only bits (vi keybindings, `alias v='nvim'`, `set -g fish_greeting`) inside `status is-interactive`, and `DOTNET_CLI_TELEMETRY_OPTOUT` (global/exported) outside so it applies to non-interactive sessions too.
- `nvim/` — lazy.nvim setup. `init.lua` requires `config/options`, `config/keybinds`, `config/lazy`. New plugins go in `lua/plugins/` (auto-imported) as lazy.nvim specs. `lazy-lock.json` is the plugin lockfile — generated, don't hand-edit. Update plugins from inside nvim with `:Lazy`.
- `install.script` — one-shot bootstrap (single-user Nix install + channel add + home-manager install). The README is stock home-manager docs, not repo-specific.

## Conventions

- No CI, tests, or formatter/linter configured. `home-manager build` is the sole verification step.
- Nix code style: keep the template's existing style; everything is currently in the single `home.nix` file.
- GUI/GPU binaries (`alacritty`, `ghostty`) are **not** installed via Nix: Nix-built GPU apps crash on this non-NixOS box (their libglvnd can't `dlopen` the system vendor drivers in `/usr/lib`). The binaries come from pacman (`sudo pacman -S alacritty ghostty`) and the `programs.*` modules in `home.nix` manage config only via `package = null`. Do not set `package` to a Nix package for these.
