{ ... }:

{
  programs.starship = {
    enable = true;

    enableZshIntegration = true;

    settings = {
      add_newline = true;

      format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      cmd_duration = {
        min_time = 500;
      };

      directory = {
        truncation_length = 3;
      };

      git_branch.symbol = " ";
      git_status.disabled = false;

      nix_shell.symbol = " ";
    };
  };
}
