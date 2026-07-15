{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    file
    tree

    unzip
    zip

    rsync

    git
    curl
    wget

    htop
    btop

    vim
    neovim

    ghostty.terminfo
  ];
}
