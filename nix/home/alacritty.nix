{ config, pkgs, ... }:

with import ../config/colors.nix;

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        startup_mode = "Maximized";
        decorations = "none";
      };
      shell = { program = "${pkgs.tmux}/bin/tmux"; };
      font = {
        size = 12;
        normal = { family = "DroidSansMono Nerd Font"; };
      };
      colors = {
        primary = {
          background = background;
          foreground = foreground;
        };

        normal = {
          black = black;
          red = red;
          green = green;
          yellow = yellow;
          blue = blue;
          magenta = magenta;
          cyan = cyan;
          white = white;
        };
        bright = { black = brightBlack; };
      };
    };
  };
}
