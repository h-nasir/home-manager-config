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

    file = {
      ".ideavimrc".source = "${currentDir}/.ideavimrc";
    };

    packages = [
      pkgs.bat
      pkgs.basedpyright
      pkgs.cmake
      pkgs.clang-tools
      pkgs.conan
      pkgs.entr
      pkgs.fastfetch
      pkgs.fd
      pkgs.fzf
      pkgs.gbenchmark
      pkgs.gcc
      pkgs.gnumake
      pkgs.htop
      pkgs.inotify-tools
      pkgs.jetbrains-toolbox
      pkgs.jdk
      pkgs.lua-language-server
      pkgs.maven
      pkgs.meslo-lgs-nf
      pkgs.nil
      pkgs.nixfmt
      pkgs.perf
      pkgs.protobuf
      pkgs.ripgrep
      pkgs.rustup
      pkgs.sdl3
      pkgs.sdl3.dev
      pkgs.tree
      pkgs.tree-sitter
      pkgs.uv
      pkgs.valgrind
      pkgs.vscode
      pkgs.wmctrl
      (if isWayland then pkgs.wl-clipboard else pkgs.xclip)
      pkgs.yazi
    ];

    sessionPath = [
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "${config.home.homeDirectory}/.nix-profile/bin/nvim";
      SHELL = "${config.home.homeDirectory}/.nix-profile/bin/fish";
    };

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

    bash = {
      enable = true;
      initExtra = ''
        if grep -qv fish /proc/$PPID/comm && [[ $SHLVL == [12] ]]; then
            SHELL=${pkgs.fish}/bin/fish exec fish
        fi
      '';
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
      sideloadInitLua = true;
      vimAlias = true;
      withRuby = false;
      withPython3 = false;
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
            bind C-j display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
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
      '';
      binds = {
        "\\ch" = {
          command = "backward-char";
        };
        "\\cl" = {
          command = "forward-char";
        };
        "\\cj" = {
          command = "down-or-search";
        };
        "\\ck" = {
          command = "up-or-search";
        };
        "\\t" = {
          command = "if not commandline -P ; commandline -f complete; end";
        };
      };
      functions = {
        fish_prompt = {
          description = "Write out the prompt";
          body = builtins.readFile ./fish/fish_prompt.fish;
        };
      };
      plugins = with pkgs.fishPlugins; [
        {
          name = "bass";
          src = bass.src;
        }
      ];
    };

    home-manager.enable = true;
  };
}
