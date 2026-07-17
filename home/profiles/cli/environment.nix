{ config, ... }:

{
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    PAGER = "less";

    LESS = "-FR";

    MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    LD_LIBRARY_PATH = "${config.home.profileDirectory}/lib";
    NODE_PATH = "${config.home.homeDirectory}/.npm-packages/lib/node_modules";

  };

  home.sessionPath = [
    "/opt/sqlcl/bin"
    "${config.home.homeDirectory}/.venv/bin"
    "${config.home.homeDirectory}/.npm-packages/bin"
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];
}
