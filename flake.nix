{
  description = "Nix shell for Inbe"; 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flutter-flake = {
      url    = "github:waotzi/flutter-flake/3.1.0";
      inputs.nixpkgs.follows  = "nixpkgs";
    };

  };

  outputs = { flutter-flake, nixpkgs, self }:
  let
    ### TODO other implement systems
    system = "x86_64-linux";
    pkgs   = import nixpkgs {
      inherit system;
    };
    dependencies = [
      pkgs.clang
      pkgs.cmake
      pkgs.ninja
      pkgs.pkgconfig
      pkgs.gtk3
      pkgs.libunwind
      pkgs.orc
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-libav
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
    ];
  in {
    devShell.${system} = pkgs.mkShell rec {
      inputsFrom = [ flutter-flake.devShell.${system} ];
      nativeBuildInputs = dependencies;
    };
  };
}
