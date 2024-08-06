{ config, pkgs, ... }:

{
  home = {

    username = "hamza";
    homeDirectory = "/home/hamza";

    stateVersion = "24.05";

    packages = [
      pkgs.fd
      pkgs.meslo-lgs-nf
      pkgs.neovim
    ];

    shellAliases = {
      ls="ls --color=auto";
      grep="grep --color=auto";
      fgrep="fgrep --color=auto";
      egrep="egrep --color=auto";

      ll = "ls -alF";

      vim = "nvim";
    };
  };

  fonts.fontconfig.enable = true;

  programs = {

    foot = {
      enable = true;
      settings = {
        main.font = "monospace:size=12";
	cursor.blink = true;
      };
    };

    git = {
      enable = true;
      userEmail = "hamzanasir@hotmail.co.uk";
      userName = "Hamza Nasir";
    };

    zsh = {
      enable = true;
      initExtra = ''
        export EDITOR="nvim";
        export VISUAL="nvim";
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
