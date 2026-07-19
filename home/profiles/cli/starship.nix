{ ... }:
{
  programs.starship = {
    enable = true;

    settings = {
      format = ''
        $directory$git_branch$git_status$fill$python$lua$nodejs$golang$haskell$rust$ruby$package$aws$docker_context$jobs$cmd_duration$line_break$character'';

      add_newline = true;
      palette = "nord";

      directory = {
        style = "bold fg:dark_blue";
        format = "[$path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = false;

        substitutions = {
          Documents = "󰈙";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
      };

      git_branch = {
        style = "fg:green";
        symbol = " ";
        format = "[on](white) [$symbol$branch ]($style)";
      };

      git_status = {
        style = "fg:green";
        format = "([$all_status$ahead_behind]($style) )";
      };

      fill.symbol = " ";

      python = {
        style = "teal";
        symbol = " ";
        format = "[${"$"}{symbol}${"$"}{pyenv_prefix}(${ "$"}{version} )(\\(${ "$"}{virtualenv}\\) )]($style)";
        pyenv_version_name = true;
        pyenv_prefix = "";
      };

      lua.symbol = " ";

      nodejs = {
        style = "blue";
        symbol = " ";
      };

      golang = {
        style = "blue";
        symbol = " ";
      };

      haskell = {
        style = "blue";
        symbol = " ";
      };

      rust = {
        style = "orange";
        symbol = " ";
      };

      ruby = {
        style = "blue";
        symbol = " ";
      };

      package.symbol = "󰏗 ";

      aws = {
        symbol = " ";
        style = "yellow";
        format = "[${"$"}symbol(${ "$"}profile )(\\[${"$"}duration\\] )]($style)";
      };

      docker_context = {
        symbol = " ";
        style = "fg:#06969A";
        format = "[${"$"}symbol]($style) ${"$"}path";
        detect_files = [
          "docker-compose.yml"
          "docker-compose.yaml"
          "Dockerfile"
        ];
        detect_extensions = [ "Dockerfile" ];
      };

      jobs = {
        symbol = " ";
        style = "red";
        number_threshold = 1;
        format = "[${"$"}symbol]($style)";
      };

      cmd_duration = {
        min_time = 500;
        style = "fg:gray";
        format = "[${"$"}duration]($style)";
      };

      palettes = {
        nord = {
          dark_blue = "#5E81AC";
          blue = "#81A1C1";
          teal = "#88C0D0";
          red = "#BF616A";
          orange = "#D08770";
          green = "#A3BE8C";
          yellow = "#EBCB8B";
          purple = "#B48EAD";
          gray = "#434C5E";
          black = "#2E3440";
          white = "#D8DEE9";
        };

        onedark = {
          dark_blue = "#61afef";
          blue = "#56b6c2";
          red = "#e06c75";
          green = "#98c379";
          purple = "#c678dd";
          cyan = "#56b6c2";
          orange = "#be5046";
          yellow = "#e5c07b";
          gray = "#828997";
          white = "#abb2bf";
          black = "#2c323c";
        };
      };
    };
  };
}
