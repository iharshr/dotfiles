{ config, pkgs, ... }:

{
  home.stateVersion = "25.11";
  home.username = "harsh";
  home.homeDirectory = "/home/harsh";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    docker
    ffmpeg
    python3
    stow
    nodejs_24
    yarn
    pnpm
    gotests
    gopls
    impl
    delve
    go-tools
    git
  ];

  # Neovim managed by Home Manager
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = true;
  };
}
