# dotfiles

Managed with [chezmoi](https://chezmoi.io). Shared between the Fedora desktop (`dsd`) and laptop (`dsm`).

## New machine

```bash
sudo dnf install -y chezmoi
chezmoi init --apply git@github.com:davisthedev/dotfiles.git
```

Run it from a GNOME terminal so the GNOME settings step can reach the session.

## What's here

- Shell: zsh + oh-my-zsh (pulled in by `.chezmoiexternal.toml`), Starship prompt, mise.
- `dot_*`: home dotfiles. `private_dot_ssh/config`: SSH hosts (keys are per-machine and never committed).
- `packages/`: dnf and flatpak lists, installed by `run_onchange_before_10-packages.sh.tmpl`.
- `dconf/gnome.ini`: keybindings, appearance, Ptyxis. Loaded by `run_onchange_after_30-gnome.sh.tmpl`.
- `system/nvidia/`: keeps the NVIDIA driver in the initramfs so the LUKS prompt shows on the
  NVIDIA card. Installed only on machines with an NVIDIA driver loaded.

## Secrets

Tokens go in `~/.config/zsh/secrets.zsh` (sourced by `.zshrc`, not in this repo).

## Day to day

- Edit: `chezmoi edit ~/.zshrc`, or edit the file, then `chezmoi re-add`.
- Sync: `chezmoi update` (pulls and applies), `chezmoi cd` then commit and push.
- GNOME settings changed? Copy the keys you want into `dconf/gnome.ini` (`dconf dump /org/gnome/...`).
