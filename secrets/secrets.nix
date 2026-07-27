# Reglas de agenix: qué claves públicas pueden descifrar cada secreto.
# Edita un secreto con:  nix run github:ryantm/agenix -- -e <nombre>.age
# (ejecútalo desde este directorio; usa las claves listadas abajo).
let
  # Clave personal del admin: permite editar los secretos con la identidad SSH
  # por defecto (~/.ssh/id_ed25519), que es la que busca `agenix -e`.
  admin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2c7PDtuKcnbpnJeUI4CPNncKfK/h3+5q0R/acTV/2q david.rubert@gmail.com";

  # Clave agenix de cada host, autocontenida en su directorio hosts/<nombre>/.
  mimir = import ../hosts/mimir/keys.nix;
in
{
  "cloudflared-token-mimir.age".publicKeys = [ admin mimir ];
  "pihole-password-mimir.age".publicKeys = [ admin mimir ];
  "login-password-mimir.age".publicKeys = [ admin mimir ];
}
