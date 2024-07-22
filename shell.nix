{ pkgs ? import <nixpkgs> { 
    config = { 
      android_sdk.accept_license = true;
      allowUnfree = true;
    }; 
  }
}:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "9.0";
    toolsVersion = "26.1.1";
    platformToolsVersion = "34.0.5";
    buildToolsVersions = [ "30.0.3" "33.0.0" ]; 
    includeEmulator = false;
    emulatorVersion = "32.1.15"; 
    platformVersions = [ "28" "29" "30" "33" ]; 
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.22.1" ];
    includeNDK = true;
    ndkVersions = ["25.2.9519653"];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [
      "extras;google;gcm"
    ];
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Flutter
    flutter316

    # Android dependencies
    androidComposition.androidsdk
    jdk17  # Updated to JDK 17

    # Chrome
    google-chrome

    # Additional tools
    git
    which
    unzip
  ];

  # Set up environment variables
  shellHook = ''
    export ANDROID_HOME=${androidComposition.androidsdk}/libexec/android-sdk
    export CHROME_EXECUTABLE=${pkgs.google-chrome}/bin/google-chrome-stable
    export PATH=$PATH:$ANDROID_HOME/platform-tools
  '';
}