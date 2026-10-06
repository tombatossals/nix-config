{ config, host, ... }:
{
  # Contraseña de aplicación de Gmail, descifrada por agenix (antes se leía de
  # /etc/nixos/msmtp-password, fichero que no existía). Queda en root:root
  # 0400: solo root puede enviar correo, que es quien lo hace (avisos de
  # systemd como mikrotik-backup-aviso).
  age.secrets."msmtp-password".file = ../../../secrets/msmtp-password-${host}.age;

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
        passwordeval = "cat ${config.age.secrets."msmtp-password".path}";
      };
    };
  };

  # Crear aliases para el sistema de correo
  environment.etc."aliases".text = ''
    root: david.rubert@gmail.com
    default: david.rubert@gmail.com
  '';
}
