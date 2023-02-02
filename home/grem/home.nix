{
  config,
  outputs,
  pkgs,
  lib,
  ...
}: {
  home = {
    username = "grem";
    # homeDirectory = pkgs.lib.mkForce "/home/grem";
    homeDirectory = "/home/grem";
    stateVersion = "23.05";
    extraOutputsToInstall = [];

    file = {
      "awesome" = {
        source = ./awesome;
        target = "/home/grem/.config/awesome";
      };
    };
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      userName = "grem-newfield";
      userEmail = "novoger123@gmail.com";
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        any-nix-shell fish --info-right | source
      '';
      shellInit = ''
        # Disable fish greeting
        set -g fish_greeting
      '';
      shellAliases = {
        commit = "git add . && git commit -m";
      };
    };

    helix = {
      enable = true;
      settings = {
        # theme = "rose_pine"
        # theme = "autumn_night"
        # theme = "flatwhite"
        theme = "my_theme";

        editor = {
          # line-number = "relative"
          auto-completion = true;
          auto-format = true;
          completion-trigger-len = 2;
          color-modes = true;
          shell = ["fish" "-c"];
          # rulers = [80]
          bufferline = "multiple";
          # auto-pairs = false
          # scrolloff = 79
        };

        editor.whitespace.render = {
          tab = "all";
        };

        editor.whitespace.characters = {
          tab = "~";
          tabpad = " ";
        };

        editor.statusline = {
          left = ["mode" "spinner" "file-name"];
          center = [];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
          separator = "│";
        };
        editor.cursor-shape = {
          normal = "block";
          insert = "underline";
          select = "block";
        };
        keys.normal = {
          C-s = ":w";
          C-p = ":open ~/.config/helix/config.toml";
          C-q = ":wq";
          g = {a = "code_action";};
        };

        keys.normal.space = {
          f = "no_op";
          "'" = "no_op";
          space = "file_picker";
          w = ":w";
          q = ":wq";
          C = ":config-reload";
          c = ":buffer-close";
          n = ":buffer-next";
        };
        # [keys.insert]
        # C-s = "<esc>:wi"
      };
      themes = {
      };
    };
  };
}
