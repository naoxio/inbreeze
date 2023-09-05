# Inner Breeze
A breathing tracker for the Wim Hof breathing method.

## Getting Started
To quickly run the project locally you can use the ```nix develop``` command to create a nix shell with all the dependencies fetched and ready to ```flutter run -d linux```.

For other devices you can first run ```flutter devices``` to see what is available and then target the device of your choice.

Currently the nix devolpment environment is configured to successfully run on linux, chrome and android.

See the resources below for more information

 - [Nix](https://nixos.org/)
 - [Nix flakes](https://nixos.wiki/wiki/Flakes)
 - [Flutter flake](https://github.com/waotzi/flutter-flake)

## Roadmap to 1st release
The current goal is to make the entire process functional and become ready to publish on F-droid.

### Quests to do
- [x] add step3 in the exercise, breath in and hold
- [x] repeat processes
- [x] display session data when ending the session and storing it locally
- [x] add progress view
- [x] add breathing configuration to settings page
- [ ] add info section in the settings with external links
- [ ] android and web build polishing
- [ ] option to add relaxing music during the exercise
- [x] add loading screen
- [x] github action to automatically build android apks

## Community
We welcome any participates and you should feel welcome to share your ideas.

- [Telegram](https://t.me/naoxio)
- [Twitter](https://twitter.com/naox_io)

## Releases
A few releases are automatically updated through github actions.

Only the android and linux builds have been tested.

[Releases](https://github.com/naoxio/inbe/releases/tag/latest)

### Web
Latest Web build can be found on the website:

[naox.io/inbe/#/](https://naox.io/inbe/#/)

