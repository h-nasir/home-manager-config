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
> You may need to use `home-manager switch --impure -b backup` on first activation to allow overwriting the manually created `nix.conf`. After this the config file will be managed by home manager itself.

Upon activation you may see a warning like this:
```bash
This non-NixOS system is not yet set up to use the GPU
with Nix packages. To set up GPU drivers, run
  sudo /nix/store/ihpwl7vbmyqxacx5zwal62k172la5w2c-non-nixos-gpu/bin/non-nixos-gpu-setup
```
You will need to run this command to allow Nix-managed OpenGL applications (e.g. ghostty) to work correctly.

> [!NOTE]
> If SELinux is enabled you will likely see the error `Failed to enable unit: Access denied`. You can workaround this by [changing SELinux to permissive mode](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/using_selinux/changing-selinux-states-and-modes_using-selinux#changing-to-permissive-mode_changing-selinux-states-and-modes).

## Additional Config

### Fish
Add to `.bashrc` to execute fish on shell startup:
```bash
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" \
      && -z ${BASH_EXECUTION_STRING} \
      && ${SHLVL} == 1 \
      && -x "$(command -v fish)" ]]
then
    shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
    exec fish $LOGIN_OPTION
fi
```
