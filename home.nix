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
            escapeTime = 0;
            focusEvents = true;
            mouse = true;
            terminal = "screen-256color";
            extraConfig = ''
                bind '\' split-window -h
                bind '-' split-window -v

            '';
            plugins = with pkgs.tmuxPlugins; [
                vim-tmux-navigator
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
            '';
            interactiveShellInit = ''
                if type -q tmux; and test -n "$DISPLAY"; and test -z "$TMUX"
                    tmux new-session -A -s $USER
                end
            '';
        };

        home-manager.enable = true;
    };
}
