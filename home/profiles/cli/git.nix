{ pkgs, ... }:

{
  home.packages = with pkgs; [
    difftastic # diff que entiende la sintaxis, no solo las líneas
    git-absorb # reparte los cambios del working tree entre los commits que tocan
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "David Rubert";
        email = "david.rubert@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };

      # difftastic bajo demanda (`git dft`), no por defecto: el diff normal
      # sigue pasando por delta (ver delta.nix).
      diff = {
        tool = "difftastic";
      };
      difftool = {
        prompt = false;
        difftastic = {
          cmd = ''difft "$LOCAL" "$REMOTE"'';
        };
      };
      alias = {
        dft = "difftool";
      };
    };

    lfs.enable = true;
  };
}
