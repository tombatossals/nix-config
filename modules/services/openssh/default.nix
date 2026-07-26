{ ... }:

{
  services.openssh = {
    enable = true;

    settings = {
      # Solo autenticación por clave. Las claves autorizadas se declaran por
      # usuario (users.users.<name>.openssh.authorizedKeys.keys).
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };

    openFirewall = true;
  };
}
