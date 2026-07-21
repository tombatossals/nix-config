# Reglas de agenix: qué claves públicas pueden descifrar cada secreto.
# Edita un secreto con:  nix run github:ryantm/agenix -- -e cloudflared-token-mimir.age
# (ejecútalo desde este directorio; usa las claves listadas abajo).
let
  # SUSTITUYE por claves públicas reales.
  #  - La de un usuario (para poder editar el secreto desde tu máquina):
  #      cat ~/.ssh/id_ed25519.pub
  #  - La del host mimir (para que pueda descifrarlo al arrancar):
  #      ssh-keyscan mimir   ó   cat /etc/ssh/ssh_host_ed25519_key.pub
  admin = "ssh-ed25519 AAAA_SUSTITUYE_POR_TU_CLAVE_DE_USUARIO";
  mimir = "ssh-ed25519 AAAA_SUSTITUYE_POR_LA_CLAVE_DEL_HOST_MIMIR";
in
{
  "cloudflared-token-mimir.age".publicKeys = [ admin mimir ];
}
