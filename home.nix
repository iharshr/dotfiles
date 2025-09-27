{ config, pkgs, ... }:

{
  # 🔹 Set username & home explicitly (flakes don't use env vars)
  home.stateVersion = "25.11";
  home.username = "harsh";
  home.homeDirectory = "/home/harsh";

  programs.home-manager.enable = true;

  # 🔹 Packages managed by Home Manager
  home.packages = with pkgs; [
    docker
    neovim
    ffmpeg
    python3
    stow
    nodejs_latest_lts
    yarn
    pnpm
    gotests
    gopls
    impl
    goplay
    dlv
    staticcheck
    zsh
    git
  ];

  # 🔹 Zsh config
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
    plugins = [
      { name = "git"; }
      { name = "zsh-autosuggestions"; }
      { name = "zsh-syntax-highlighting"; }
      { name = "zsh-autocomplete"; }
    ];
  };

  # 🔹 Neovim config
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    # You can also manage plugins via nixpkgs.vimPlugins.* if desired
    plugins = [ ];
  };
}
