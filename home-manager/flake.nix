{
  description = "Home Manager configuration of blazzee";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Custom patched Suckless builds
      myDwm = pkgs.stdenv.mkDerivation {
        pname = "dwm";
        version = "patched";
        src = ./suckless/dwm;
        nativeBuildInputs = [ pkgs.fontconfig pkgs.xorg.libX11 pkgs.xorg.libXft pkgs.jetbrains-mono ];
        installPhase = ''
          make PREFIX=$out install
        '';
      };

      myDmenu = pkgs.stdenv.mkDerivation {
        pname = "dmenu";
        version = "patched";
        src = ./suckless/dmenu;
        nativeBuildInputs = [ pkgs.fontconfig pkgs.xorg.libX11 pkgs.xorg.libXft pkgs.jetbrains-mono ];
        installPhase = ''
          make PREFIX=$out install
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

      # List all scripts in scripts/ directory
      scriptFiles = builtins.attrNames (builtins.readDir ./scripts);

    in
    {
      homeConfigurations."blazzee" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home.username = "blazzee";
            home.homeDirectory = "/home/blazzee";

            programs.home-manager.enable = true;
            home.stateVersion = "24.05";

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
            ];

            # Dunst config
            home.file.".config/dunst/dunstrc".source = ./dunst/dunstrc;
            # Desktop entry for DWM
            home.file.".local/share/xsessions/dwm.desktop".text = ''
              [Desktop Entry]
              Name=DWM
              Comment=Dynamic Window Manager
              Exec=$HOME/.config/home-manager/suckless/autostart.sh
              TryExec=${myDwm}/bin/dwm
              Type=XSession
            '';

            # Enable X session support
            xsession.enable = true;
            xsession.windowManager.command = "${myDwm}/bin/dwm";
          }
        ];
      };
    };
}
