import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'router/router.dart';
import 'utils/platform_checker.dart';
import 'package:flutter/services.dart';

const String title = 'Inner Breeze';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isDesktop()) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: Size(420, 600),
      center: true,
      title: title,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      
      runApp(App());
    });
  }
  else {
    runApp(App());
  }
}

final _darkTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark,
  ),
);

final _lightTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.light,
  ),
);

class App extends StatefulWidget {
  // Creates an [App].
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    if (!isDesktop()) {
      _preloadAssets(context);
    }
  }

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
        await rootBundle.load(assetPath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: title,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
