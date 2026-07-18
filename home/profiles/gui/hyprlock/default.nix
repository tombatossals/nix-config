{ ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 2;
      };

      background = [
        {
          color = "rgb(1e1e2e)";
        }
      ];

      input-field = [
        {
          size = "300, 60";
          position = "0, -80";

          outline_thickness = 2;

          outer_color = "rgb(89b4fa)";
          inner_color = "rgb(11111b)";
          font_color = "rgb(cdd6f4)";
          check_color = "rgb(a6e3a1)";
          fail_color = "rgb(f38ba8)";

          fade_on_empty = false;
          placeholder_text = "Contraseña...";
        }
      ];

      label = [
        {
          text = "$TIME";
          font_size = 64;
          position = "0, 120";
          halign = "center";
          valign = "center";
          color = "rgb(cdd6f4)";
        }

        {
          text = "Hola, $USER";
          font_size = 20;
          position = "0, 40";
          halign = "center";
          valign = "center";
          color = "rgb(bac2de)";
        }
      ];
    };
  };
}
