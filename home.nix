{ config, pkgs, ... }:

{
    nix = {
        package = pkgs.nix;
        settings.experimental-features = [ "nix-command" "flakes" ];
    };

    nixpkgs.config.allowUnfree = true;

    targets.genericLinux.enable = true;

    xdg.mime.enable = true;
    xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

    home = {

        username = "hamza";
        homeDirectory = "/home/hamza";

        stateVersion = "25.11";

        packages = [
            pkgs.basedpyright
            pkgs.cmake
            pkgs.clang-tools
            pkgs.fastfetch
            pkgs.fd
            pkgs.gcc
            pkgs.gnumake
            pkgs.htop
            pkgs.jdk
            pkgs.lua-language-server
            pkgs.maven
            pkgs.meslo-lgs-nf
            pkgs.nil
            pkgs.protobuf
            pkgs.ripgrep
            pkgs.sublime
            pkgs.tree
            pkgs.uv
            # pkgs.vcpkg # Disabled until vcpkg supports fmt12
            pkgs.vscode
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

        file = {
            "./.config/nvim/" = {
                source = config.lib.file.mkOutOfStoreSymlink ./apps/nvim;
                recursive = true;
            };
            "./.config/foot/" = {
                source = config.lib.file.mkOutOfStoreSymlink ./apps/foot;
                recursive = true;
            };
            "./.config/ghostty/" = {
                source = config.lib.file.mkOutOfStoreSymlink ./apps/ghostty;
                recursive = true;
            };
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
            plugins = [
                pkgs.tmuxPlugins.vim-tmux-navigator
            ];
        };

        zsh = {
            enable = true;
            defaultKeymap = "emacs";
            plugins = [
            {
                name = "p10k-config";
                src = config.lib.file.mkOutOfStoreSymlink ./p10k;
                file = "p10k.zsh";
            }
            {
                name = "zsh-powerlevel10k";
                src = pkgs.zsh-powerlevel10k;
                file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
            ];
        };

        home-manager.enable = true;
    };
}
