{ config, pkgs, ... }:

let
  currentDir = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager";

  configRoot = "apps";
  configDirs = builtins.attrNames (builtins.readDir ./${configRoot});

  isWayland = builtins.getEnv "XDG_SESSION_TYPE" == "wayland";
in
{
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  targets.genericLinux.enable = true;

  xdg = {
    mime.enable = true;
    systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

    configFile = builtins.listToAttrs (
      map (dir: {
        name = dir;
        value = {
          source = "${currentDir}/${configRoot}/${dir}";
        };
      }) configDirs
    );
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
      pkgs.fzf
      pkgs.gcc
      pkgs.gnumake
      pkgs.htop
      pkgs.inotify-tools
      pkgs.jdk
      pkgs.lua-language-server
      pkgs.maven
      pkgs.meslo-lgs-nf
      pkgs.nil
      pkgs.nixfmt
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
      (if isWayland then pkgs.wl-clipboard else pkgs.xclip)
      pkgs.yazi
    ];

    sessionVariables = {
      # VCPKG_ROOT = "${pkgs.vcpkg}/share/vcpkg";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];

    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";

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
      terminal = "xterm-256color";
      extraConfig = ''
        set -as terminal-overrides ",*256color*:RGB"

        bind '\' split-window -h
        bind '-' split-window -v
      '';
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = tmux-fzf;
          extraConfig = ''
            bind C-j display-popup "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
            bind C-f split-window -v "fd -a --type f | fzf --reverse --preview 'bat --plain --color=always {}' | xargs -I {} tmux send-keys -t 0 nvim Space {} Enter"
            bind C-d split-window -v "fd -a --type d | fzf --reverse | xargs -I {} tmux send-keys -t 0 cd Space {} Enter"
          '';
        }
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
