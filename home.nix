{ config, pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;

    targets.genericLinux.enable = true;

    xdg.mime.enable = true;
    xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

    home = {

        username = "hamza";
        homeDirectory = "/home/hamza";

        stateVersion = "25.11";

        packages = [
            pkgs.cmake
            pkgs.gcc
            pkgs.fastfetch
            pkgs.fd
            pkgs.gnumake
            pkgs.htop
            pkgs.jdk
            pkgs.meslo-lgs-nf
            pkgs.nil
            pkgs.basedpyright
            pkgs.protobuf
            pkgs.python312
            pkgs.ripgrep
            pkgs.sublime
            pkgs.tree
            pkgs.uv
            pkgs.vcpkg
            pkgs.vscode
        ];

        sessionVariables = {
            VCPKG_ROOT = "${pkgs.vcpkg}/share/vcpkg";
        };

        shellAliases = {
            ls="ls --color=auto";
            grep="grep --color=auto";
            fgrep="fgrep --color=auto";
            egrep="egrep --color=auto";

            ll = "ls -alF";
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
        };
    };

    fonts.fontconfig.enable = true;

    programs = {

        foot = {
            enable = true;
        };

        git = {
            enable = true;
            userEmail = "hamzanasir@hotmail.co.uk";
            userName = "Hamza Nasir";
        };

        neovim = {
            enable = true;
            defaultEditor = true;
            vimAlias = true;
        };

        zsh = {
            enable = true;
            initContent = ''
                bindkey -v '^?' backward-delete-char
                bindkey '^R' history-incremental-search-backward
                '';
            plugins = [
            {
                name = "p10k-config";
                src = ./p10k;
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
