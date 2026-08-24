{ pkgs, ... }:

{
  home.packages = with pkgs; [
    shellcheck # análisis estático de scripts sh/bash
    shfmt # formateador de scripts
  ];
}
