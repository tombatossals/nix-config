{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    clang
    clang-tools
    cmake
    ninja
    gdb
    lldb
  ];
}
