# AGENTS.md

Home Manager dotfiles for user `anon`. Standalone, **channel-based** setup (no flake) on non-NixOS Arch, single-user Nix. Channels pinned to stable: `nixpkgs` = `nixos-26.05`, `home-manager` = `release-26.05` (see `install.script`).

## Commands

- Verify without touching the live profile: `home-manager build`. It prints the generation path last; built files live under that path's `home-files/`.
- Apply: `home-manager switch`.
- `home-manager build` is the **only** verification step. No CI, no lint, no tests.
- After editing `config.fish`: `fish -n config.fish` checks syntax only — it will **not** catch runtime errors like a misquoted `alias`. Test the interactive block with `fish -ic 'source ~/.config/home-manager/config.fish'` or just open a fresh fish.
- Channel bump: `nix-channel --update && home-manager switch`.

## Rules (hard-earned — don't break)

- **GPU binaries come from pacman, not Nix.** `programs.alacritty` and `programs.ghostty` manage config only via `package = null`. Nix-built GPU apps crash on this box: the Nix `libglvnd` searches only Nix-store paths and can't `dlopen` the system NVIDIA/mesa vendor drivers in `/usr/lib` → `EGL_NO_DISPLAY` → SIGSEGV. This already broke Nix kitty/ghostty. Never set these packages to a Nix package.
- `programs.ghostty.systemd.enable = false` is required with `package = null`: the module's systemd unit needs the Nix ghostty; pacman ships its own.
- alacritty theme is imported from `${pkgs.alacritty-theme}/share/alacritty-theme/rose_pine_moon.toml` (underscores; that's the filename inside the package). Do **not** switch to the module's `theme` option — it reads `cfg.package.version`, which crashes at eval when `package = null`.
- **`programs.fish` is off-limits.** Its `package` is non-nullable → would install Nix fish (4.7) shadowing the system fish (4.8). A previous Nix-fish install broke fish config at login and needed a backup restore. fish stays a plain `home.file` symlink to `./config.fish`.
- **`programs.neovim` is off-limits.** Package non-nullable → installs a Nix nvim that shadows the system binary and collides with the whole-dir `home.file` symlink + lazy.nvim. nvim is system-installed; HM only links the config dir.
- `home.stateVersion = "25.11"` — never bump.

## Repo layout

- `home.nix` — the only Nix entrypoint. `home.file` symlinks `config.fish` and the `nvim/` dir; the `programs` block holds `home-manager`, `alacritty`, `ghostty`.
- `config.fish` — split interactive vs non-interactive (header comment explains what goes where). Interactive block: greeting suppression (`set -g`, **not** `-U` — universal vars persist in `~/.config/fish/fish_variables` even after you remove the line), `fish_vi_key_bindings`, aliases (CPU-governor helpers use `sudo`). Outside: `DOTNET_CLI_TELEMETRY_OPTOUT` (`-gx`) so non-interactive sessions get it too.
- `nvim/` — lazy.nvim. `init.lua` requires `config/{options,keybinds,lazy}`; new plugins go in `lua/plugins/*.lua` (auto-imported via `require("plugins")`). The lockfile is `stdpath("cache")/lazy-lock.json` (writable, unversioned) — do not expect it in the repo.
- `install.script` — one-shot bootstrap; pinned stable channels.
- `README.md` — stock home-manager README, not repo-specific.

## Gotcha

Dotfiles are **not** picked up automatically: `home.file` only ships what's declared (fish config + nvim dir). Adding a dotfile requires a new `home.file` entry + rebuild. Live files under `~/.config/...` are read-only symlinks into the Nix store — edits there are lost on the next switch; edit the source tree here and rebuild.