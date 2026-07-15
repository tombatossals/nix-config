{ ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    historyLimit = 100000;
    terminal = "screen-256color";
    escapeTime = 10;
    baseIndex = 1;
    clock24 = true;
    sensibleOnTop = true;
  };
}
