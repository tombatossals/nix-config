{ ... }:

{
  programs.zsh.shellAliases = {
    # ls
    l = "eza";
    ll = "eza -lh --git";
    la = "eza -lah --git";
    lt = "eza --tree";

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

    # rebuild (ya que usamos flakes)
    ns = "sudo nixos-rebuild switch --flake ~/nix-config#pulsar";
    nb = "sudo nixos-rebuild boot --flake ~/nix-config#pulsar";
    nt = "sudo nixos-rebuild test --flake ~/nix-config#pulsar";
    nc = "nix flake check ~/nix-config";
  };
}
