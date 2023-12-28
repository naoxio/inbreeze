# Inner Breeze
Guided breathing meditation app based on the Wim Hof breathing method.

## Current Goals
- [ ] add multilingual support, add german translations
- [ ] add gong sfx before the start of the breath hold
- [ ] fix breath in after finishing a round
- [ ] improve breathing speed selection
## Getting Started

### Nix OS

To quickly run the project locally on Nix OS, use the `nix develop` command. This sets up a Nix shell with all dependencies fetched, ready for development. To run the application on Linux, execute `flutter run -d linux`.

For targeting other devices:
1. Run `flutter devices` to list available devices.
2. Target your chosen device with the appropriate command.

The Nix development environment is configured to run successfully on Linux, Chrome, and Android.

Helpful Resources:
- [Nix Official Site](https://nixos.org/)
- [Understanding Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Flutter Flake on GitHub](https://github.com/waotzi/flutter-flake)

### Other Linux Distributions

For development on other Linux distributions:

1. **Clone the Repository with Submodules**: 
   Use `git submodule update --init --recursive   ` to ensure you have the `.flutter` submodule.

2. **Install Flutter Dependencies**:
   Install all necessary dependencies for Flutter, including libraries for Android development (if targeting Android devices) and web browsers for web development.

3. **Run `flutter doctor`**:
   Execute `.flutter/bin/flutter doctor` from the project directory to check your environment. Address any issues it reports.

4. **Check Available Devices**:
   Run `.flutter/bin/flutter devices` to see available devices.

5. **Target a Device for Development**:
   For instance, to run on Linux, use `.flutter/bin/flutter run -d linux`.

## Community
We welcome any participates and you should feel welcome to share your ideas.

- [Telegram](https://t.me/naoxio)
- [Twitter](https://twitter.com/naox_io)

## Releases
Automatically updated via GitHub Actions.

### Get the App
<p align="center">
 <a href="https://inner-breeze.app/#/">
  <img src="./docs/web-app.png"
    alt="Open Web App"
    height="60">
 </a>
 <a href="https://flathub.org/apps/io.naox.InnerBreeze">
  <img src="./docs/flathub-badge-en.png"
    alt="Download on Flathub"
    height="60">
 </a>
 <a href="https://f-droid.org/packages/io.naox.inbe">
  <img src="./docs/get-it-on.png"
    alt="Get it on F-Droid"
    height="60">
 </a>
</p>


[![Netlify Status](https://api.netlify.com/api/v1/badges/9fe7d682-4647-42d3-8d29-53737c9ffe05/deploy-status)](https://app.netlify.com/sites/inbe/deploys)
