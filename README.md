# dotfiles

Cross-distro dotfiles for Manjaro Linux, Ubuntu, and Fedora.

The common user environment is managed by the Nix package manager and Home
Manager. Distro package managers are used only for minimal bootstrap and
OS-integrated desktop setup.

## Policy

- Common CLI and development tools are installed through Nix/Home Manager.
- `mise` is the tool/runtime manager package. `fnm` is not used.
- Chrome and VS Code are not installed through Nix.
- `.bin/lib/desktop-setup.sh` covers Japanese input, fonts, and browser MIME
  defaults only.
- Docker daemon setup, Chrome installation, and VS Code installation are manual
  distro-specific steps.
- Existing dotfiles are linked into home by `.bin/install.sh`.

## Install

Clone this repository:

```
git clone https://github.com/takuyaw-w/dotfiles.git ~/.dotfiles
```

Install Nix if needed:

```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Install the Home Manager command if needed:

```
nix profile install github:nix-community/home-manager
```

Run the installer:

```
~/.dotfiles/.bin/install.sh
```

The installer links dotfiles, runs bootstrap setup, applies gitconfig, switches
Home Manager, and then prints the desktop setup command.

## Desktop setup

Run OS/desktop-specific setup separately:

```
~/.dotfiles/.bin/lib/desktop-setup.sh
```

This currently covers Japanese input, fonts, and browser MIME defaults only.
Docker daemon setup, Chrome installation, and VS Code installation are not
performed by this script.

## Verification

Syntax-check shell scripts:

```
bash -n .bin/install.sh .bin/lib/*.sh
```

Run shell tests if `bats` is available:

```
bats tests/os-release.bats
```

Check the flake:

```
nix flake check
```

Build the Linux Home Manager activation package:

```
nix build .#homeConfigurations.takuya-x86_64-linux.activationPackage --no-link
```

Optionally build with the Home Manager command if it is available:

```
home-manager build --flake ~/.dotfiles#takuya-x86_64-linux
```
