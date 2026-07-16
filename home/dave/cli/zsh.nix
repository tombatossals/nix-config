{ config, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
      path = "${config.xdg.stateHome}/zsh/history";
    };

    dotDir = "${config.xdg.configHome}/zsh";

    initContent = ''
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line

      setopt AUTO_CD
      setopt INTERACTIVE_COMMENTS
      setopt SHARE_HISTORY
    '';

    loginExtra = ''
      if [ -z "$DISPLAY" ] \
        && [ "${XDG_VTNR:-}" = "1" ] \
        && [ -z "$SSH_CONNECTION" ]; then
          exec Hyprland
      fi
    '';
  };
}
