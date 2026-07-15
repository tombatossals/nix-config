{ ... }:

{
  programs.yazi = {
    enable = true;

    enableZshIntegration = true;

    settings = {
      manager = {
        showHidden = true;
        sortBy = "natural";
        sortDirFirst = true;
      };
    };
  };
}
