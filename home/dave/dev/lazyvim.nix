{ pkgs, inputs, ... }:

{
  imports = [
    inputs.lazyvim-nix.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    extras = {
      lang.nix.enable = true;

      lang.python = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };

      lang.go = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      nixd
      alejandra
    ];

    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      wgsl
      templ
    ];
  };
}
