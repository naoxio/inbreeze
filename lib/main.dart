import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/widgets/centered_max_width_widget.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'router/router.dart';
import 'utils/platform_checker.dart';

const String title = 'Inner Breeze';

void run() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: App(),
    ),
  );
}

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
      
      run();
    });
  }
  else {
    run();
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

    final imageAssetFilenames = [
      'angel.jpg',
      'begin.jpg',
      'logo.png',
    ];

    // Construct full paths for image assets
    final imageAssetPaths = imageAssetFilenames.map((filename) => 'assets/images/$filename').toList();

    for (final assetPath in imageAssetPaths) {
      if (imageExtensions.any((ext) => assetPath.endsWith(ext))) {
        await precacheImage(AssetImage(assetPath), context);
      }
    }
  }

  // ... other code ...

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: title,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        var backgroundColor = Theme.of(context).colorScheme.background;

        return Container(
          color: backgroundColor,
          child: CenteredMaxWidthWidget(child: child!),
        );
      },
    );
  }
}