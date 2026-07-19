{ lib, rebuildCommand, ... }:

{
  programs.zsh.shellAliases = {
    # ls
    l = "eza";
    ll = "eza -lh --git";
    la = "eza -lah --git";
    lt = "eza --tree";

    lrt = "eza -lg --sort=modified";
    lrs = "eza -lg --sort=size";

    # navegación
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # utilidades
    grep = "rg";
    du = "dust";
    df = "duf";

    # git
    g = "git";
    lg = "lazygit";

    # tmux
    ta = "tmux attach";
    tls = "tmux ls";

    nc = "nix flake check ~/nix-config";
    rebuild = rebuildCommand;
  };
}
