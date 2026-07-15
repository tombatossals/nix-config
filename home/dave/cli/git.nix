{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "David Rubert";
        email = "david.rubert@gmail.com";
      };
    };

    lfs.enable = true;
  };
}
