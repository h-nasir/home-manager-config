{ config, pkgs, ... }:

let
currentDir = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager";

configRoot = "apps";
configDirs = builtins.attrNames (builtins.readDir ./${configRoot});
in
{
    nix = {
        package = pkgs.nix;
        settings.experimental-features = [ "nix-command" "flakes" ];
    };

    nixpkgs.config.allowUnfree = true;

    targets.genericLinux.enable = true;

    xdg = {
        mime.enable = true;
        systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

        configFile = builtins.listToAttrs (map (dir: {
                    name = dir;
                    value = {
                    source = "${currentDir}/${configRoot}/${dir}";
                    };
                    }) configDirs);
    };

    home = {
        username = "hamza";
        homeDirectory = "/home/hamza";

        stateVersion = "25.05";

        packages = [
            pkgs.bat
                pkgs.basedpyright
                pkgs.cmake
                pkgs.clang-tools
                pkgs.entr
                pkgs.fastfetch
                pkgs.fd
                pkgs.gcc
                pkgs.gnumake
                pkgs.htop
                pkgs.inotify-tools
                pkgs.jdk
                pkgs.lua-language-server
                pkgs.maven
                pkgs.meslo-lgs-nf
                pkgs.nil
                pkgs.protobuf
                pkgs.ripgrep
                pkgs.rustup
                pkgs.sublime
                pkgs.tree
                pkgs.tree-sitter
                pkgs.uv
# pkgs.vcpkg # Disabled until vcpkg supports fmt12
                pkgs.vscode
                pkgs.wmctrl
                pkgs.wl-clipboard
                pkgs.yazi
                ];

        sessionVariables = {
# VCPKG_ROOT = "${pkgs.vcpkg}/share/vcpkg";
        };

        sessionPath = [
            "$HOME/.local/bin"
        ];

        shellAliases = {
            ls="ls --color=auto";
            grep="grep --color=auto";
            fgrep="fgrep --color=auto";
            egrep="egrep --color=auto";

            ll = "ls -ahlF";
        };
    };

    fonts.fontconfig.enable = true;

    programs = {

        foot = {
            enable = true;
        };

        git = {
            enable = true;
            settings = {
                user.email = "hamzanasir@hotmail.co.uk";
                user.name = "Hamza Nasir";
            };
        };

        ghostty = {
            enable = true;
        };

        neovim = {
            enable = true;
            defaultEditor = true;
            vimAlias = true;
        };

        tmux = {
            enable = true;
            keyMode = "vi";
            escapeTime = 0;
            focusEvents = true;
            mouse = true;
            terminal = "screen-256color";
            extraConfig = ''
                bind '\' split-window -h
                bind '-' split-window -v
                '';
            plugins = with pkgs.tmuxPlugins; [
            {
                plugin = vim-tmux-navigator;
                extraConfig = ''
                    set -g @vim_navigator_mapping_left "M-h"
                    set -g @vim_navigator_mapping_right "M-l"
                    set -g @vim_navigator_mapping_up "M-k"
                    set -g @vim_navigator_mapping_down "M-j"
                    set -g @vim_navigator_mapping_prev ""
                    '';
            }
            {
                plugin = resurrect;
            }
            {
                plugin = continuum;
                extraConfig = ''
                    set -g @continuum-restore 'on'
                    set -g @continuum-save-interval '1'
                    '';
            }
            ];
        };

        fish = {
            enable = true;
            shellInit = ''
                set fish_greeting

                bind \ch backward-char        # Ctrl-h  = move left
                bind \cl forward-char         # Ctrl-l  = move right

                bind \cj down-or-search       # Ctrl-j  = down
                bind \ck up-or-search         # Ctrl-k  = up
                '';
        };

        home-manager.enable = true;
    };
}
