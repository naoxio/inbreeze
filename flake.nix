{
  description = "Nix shell for Inbe"; 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flutter-flake = {
      url    = "github:waotzi/flutter-flake/3.2.1";
      inputs.nixpkgs.follows  = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = { flutter-flake, nixgl, nixpkgs, self }:
  let
    ### TODO other implement systems
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
      overlays = [ nixgl.overlay ];
    };
    dependencies = [
      pkgs.clang
      pkgs.cmake
      pkgs.ninja
      pkgs.pkg-config
      pkgs.gtk3
      pkgs.libunwind
      pkgs.orc
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-libav
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
    ];
    flutterBuild = pkgs.stdenv.mkDerivation rec {
      name = "flutter-app";
      src = ./.;
      inputsFrom = [ flutter-flake.devShell.${system} ];
      nativeBuildInputs = dependencies;
      
      buildPhase = ''
        flutter build linux --release
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp -r build/linux/x64/release/bundle/* $out/bin/
      '';
    };
  in {
    devShell.${system} = pkgs.mkShell rec {
      inputsFrom = [ flutter-flake.devShell.${system} ];
      nativeBuildInputs = dependencies;
    };
    defaultPackage.${system} = flutterBuild;
  };
}
