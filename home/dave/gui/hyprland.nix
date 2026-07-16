{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "ALT";

      monitor = ",preferred,auto,1";

      exec-once = [
        "ghostty"
      ];

      input = {
        kb_layout = "es";

        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          disable_while_typing = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;

        "col.active_border" = "rgb(89b4fa)";
        "col.inactive_border" = "rgb(313244)";
      };

      decoration = {
        rounding = 8;
      };

      misc = {
        disable_hyprland_logo = true;
      };

      bind = [
        "$mod, RETURN, exec, ghostty"
        "$mod, D, exec, fuzzel"
        "$mod, Q, killactive"
        "$mod SHIFT, E, exit"

        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        "$mod, F, fullscreen"
      ];
    };
  };
}
