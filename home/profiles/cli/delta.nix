{ ... }:

{
  programs.delta = {
    enable = true;

    # Ojo: por defecto es false, es decir, `enable` solo instala el binario
    # sin que git llegue a usarlo. Esto es lo que lo conecta como pager.
    enableGitIntegration = true;

    options = {
      navigate = true; # n / N para saltar de fichero a fichero
      line-numbers = true;
      side-by-side = false;
    };
  };
}
