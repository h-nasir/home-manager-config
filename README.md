# Home Manager Config

Config files for use with [Nix Home Manager](https://github.com/nix-community/home-manager)

## Additional Config

### Fish
Add the below to `.bashrc` to execute fish on shell startup
```bash
NIX_SHELL="$HOME/.nix-profile/bin/fish"
if [ -f $NIX_SHELL ]; then
  exec $NIX_SHELL
fi
```
