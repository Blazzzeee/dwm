{
  description = "Home Manager configuration of blazzee";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
        };
      lib = home-manager.lib;

      # Custom patched Suckless builds
      myDwm = pkgs.stdenv.mkDerivation {
        pname = "dwm";
        version = "patched";
        src = ./suckless/dwm;
        nativeBuildInputs = [ pkgs.fontconfig pkgs.xorg.libX11 pkgs.xorg.libXft pkgs.jetbrains-mono pkgs.xorg.libXinerama ];
        installPhase = ''
          make PREFIX=$out clean install
        '';
      };

      myDmenu = pkgs.stdenv.mkDerivation {
        pname = "dmenu";
        version = "patched";
        src = ./suckless/dmenu;
        nativeBuildInputs = [ pkgs.fontconfig pkgs.xorg.libX11 pkgs.xorg.libXft pkgs.jetbrains-mono pkgs.xorg.libXinerama];
        installPhase = ''
          make PREFIX=$out clean install
        '';
      };

      myDwmblocks = pkgs.stdenv.mkDerivation {
        pname = "dwmblocks";
        version = "patched";
        src = ./suckless/dwmblocks;
        nativeBuildInputs = [ pkgs.fontconfig pkgs.xorg.libX11 pkgs.xorg.libXft pkgs.jetbrains-mono ];

        buildPhase = ''
          cp blocks.def.h blocks.h
          make
        '';

        installPhase = ''
          make PREFIX=$out install
        '';
      };

    in {
      homeConfigurations."blazzee" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home.username = "blazzee";
            home.homeDirectory = "/home/blazzee";
            home.stateVersion = "24.05";
            programs.home-manager.enable = true;

            home.packages = with pkgs; [
              dunst
              myDwm
              myDmenu
              myDwmblocks
              acpi
              iw
              xclip
              nitrogen
              pamixer
              jetbrains-mono
              slack
              libinput-gestures
              xdotool
            ];

            
            home.sessionVariables.PATH = ''
              ${pkgs.corepack}/bin:$PATH
            '';
          # Dunst config
            home.file.".config/dunst/dunstrc".source = ./dunst/dunstrc;

            home.file.".config/greetd/config.toml".source =
              builtins.path { path = ./greetd/config.toml; };

            # DWM desktop entry
            home.file.".local/share/xsessions/dwm.desktop".text = ''
              [Desktop Entry]
              Name=DWM
              Comment=Dynamic Window Manager
              Exec=$HOME/.config/home-manager/suckless/autostart.sh
              TryExec=${myDwm}/bin/dwm
              Type=XSession
            '';

            # X session
            xsession.enable = true;
            xsession.windowManager.command = "${myDwm}/bin/dwm";          

            #gesture stuff
            home.file.".config/libinput-gestures.conf".text = ''
              gesture swipe left  xdotool key super+Right
              gesture swipe right xdotool key super+Left
              gesture swipe up    kitty
              gesture swipe down  dmenu_run
            '';

            # 🧠 systemd user service for gestures
            systemd.user.services.libinput-gestures = {
              Unit = {
                Description = "Libinput Gestures Daemon";
                After = [ "graphical-session-pre.target" ];
              };
              Service = {
              ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures -c $HOME/.config/libinput-gestures.conf";
                Restart = "on-failure";
              };
              Install.WantedBy = [ "graphical-session.target" ];
            };
          }
        ];
      };
    };
}
