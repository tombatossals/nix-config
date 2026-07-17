{ ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --strip-cwd-prefix";
    fileWidgetCommand = "fd --type f --strip-cwd-prefix";
    changeDirWidgetCommand = "fd --type d --strip-cwd-prefix";
  };
}
