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
> You may need to use `home-manager switch --impure -b backup` on first activation to allow overwriting the manually created `nix.conf`. After this the config file will be managed by home manager.

## Additional Config

### Fish
Add to `.bashrc` to execute fish on shell startup:
```bash
NIX_SHELL="$HOME/.nix-profile/bin/fish"
if [ -f $NIX_SHELL ]; then
  exec $NIX_SHELL
fi
```
