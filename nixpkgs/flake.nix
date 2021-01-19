{
  description = "NixOS configuration";
  inputs = {
    # zsh Plugins
    zsh-node-path = {
      url = "github:andyrichardson/zsh-node-path";
      flake = false;
    };
    zsh-completions = {
      url = "github:zsh-users/zsh-completions";
      flake = false;
    };
    zsh-autosuggestions = {
      url = "github:zsh-users/zsh-autosuggestions";
      flake = false;
    };
    zsh-syntax-highlighting = {
      url = "github:zsh-users/zsh-syntax-highlighting";
      flake = false;
    };
    zsh-256color = {
      url = "github:chrissicool/zsh-256color";
      flake = false;
    };
    zsh-nvm = {
      url = "github:lukechilds/zsh-nvm";
      flake = false;
    };
    zsh-better-npm-completion = {
      url = "github:lukechilds/zsh-better-npm-completion";
      flake = false;
    };
    zsh-autoswitch-virtualenv = {
      url = "github:MichaelAquilina/zsh-autoswitch-virtualenv";
      flake = false;
    };
    zsh-powerline = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };
    powerline = {
      url = "github:powerline/powerline";
      flake = false;
    };
    # Vscode plugins
    nixpkgs.url = "github:nixos/nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  

  outputs = inputs: {
    defaultPackage.x86_64-darwin = (inputs.darwin.lib.darwinSystem {
      modules = [ 
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.users.andyrichardson = import ./home.nix inputs;
        }

        ({ pkgs, ... }: {
          fonts = {
            enableFontDir = true;
            fonts = [ (pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" "DroidSansMono" "RobotoMono" "Hack" "SourceCodePro" ]; }) ];
          };
        })
      ];
    }).system;
  };
}
