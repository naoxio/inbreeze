import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _preloadAssets(BuildContext context) async {
    final imageExtensions = ['.png', '.jpg', '.jpeg'];
    final soundExtensions = ['.mp3', '.wav', '.ogg'];

    final imageAssetFilenames = [
      'angel.png',
      'begin.jpg',
      'logo.jpg',
    ];

    final soundAssetFilenames = [
      'breath-in.ogg',
      'breath-out.ogg',
    ];

    // Construct full paths
    final imageAssetPaths = imageAssetFilenames.map((filename) => 'assets/images/$filename').toList();
    final soundAssetPaths = soundAssetFilenames.map((filename) => 'assets/sounds/$filename').toList();

    final allAssets = [...imageAssetPaths, ...soundAssetPaths];

    for (final assetPath in allAssets) {
      if (imageExtensions.any((ext) => assetPath.endsWith(ext))) {
        await precacheImage(AssetImage(assetPath), context);
      } else if (soundExtensions.any((ext) => assetPath.endsWith(ext))) {
        // For sounds, we're assuming they are not text files so we're using rootBundle.load instead of loadString
        await rootBundle.load(assetPath);
      }
    }
  }

  Future<bool> _checkTutorialCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tutorialComplete') ?? false;
  }

  @override
  void initState() {
    super.initState();
    _preloadAssets(context).then((_) {
      // After assets are preloaded, check tutorial completion and navigate accordingly
      _checkTutorialCompletion().then((isComplete) {
        if (isComplete) {
          context.go('/home');
        } else {
          context.go('/guide/welcome'); // Replace with your default route
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // Display a loading indicator while checking
    );
  }
}
