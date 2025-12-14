# Home Manager Config

Config files for use with [Nix Home Manager](https://github.com/nix-community/home-manager)

## Usage

Follow [instructions](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone) to install standalone home manager.

Add the following to `~/.config/nix/nix.conf` to enable flake-based config:
```
experimental-features = nix-command flakes
```

Activate environment with:
```bash
home-manager switch --impure
```
> [!NOTE]
> The `--impure` flag is necessary to determine the XDG session type at runtime

## Additional Config

### Fish
Add to `.bashrc` to execute fish on shell startup:
```bash
NIX_SHELL="$HOME/.nix-profile/bin/fish"
if [ -f $NIX_SHELL ]; then
  exec $NIX_SHELL
fi
```
