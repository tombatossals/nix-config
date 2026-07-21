{ pkgs, ... }:
{
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 587;
      tls = true;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
    };
    accounts = {
      default = {
        host = "smtp.gmail.com";
        auth = true;
        user = "david.rubert@gmail.com";
        from = "david.rubert@gmail.com";
        passwordeval = "cat /etc/nixos/msmtp-password";
      };
    };
  };

  # Crear aliases para el sistema de correo
  environment.etc."aliases".text = ''
    root: david.rubert@gmail.com
    default: david.rubert@gmail.com
  '';
}
