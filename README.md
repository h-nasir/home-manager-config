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

After first activation you should see a warning that looks like something the following.
```bash
This non-NixOS system is not yet set up to use the GPU
with Nix packages. To set up GPU drivers, run
  sudo /nix/store/ihpwl7vbmyqxacx5zwal62k172la5w2c-non-nixos-gpu/bin/non-nixos-gpu-setup
```
You will need to run this command to allow Nix-managed OpenGL applications (e.g. ghostty) to work correctly.

> [!NOTE]
> If SELinux is enabled you will likely see the error `Failed to enable unit: Access denied`. You can use `setenforce 0` before running the command to temporarily place SELinux into permissive mode, then use `setenforce 1` after this to reset back to enforcing mode.

## Additional Config

### Fish
Add to `.bashrc` to execute fish on shell startup:
```bash
NIX_SHELL="$HOME/.nix-profile/bin/fish"
if [ -f $NIX_SHELL ]; then
  exec $NIX_SHELL
fi
```
