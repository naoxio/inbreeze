import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'router/router.dart';
import 'utils/platform_checker.dart';

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

class App extends StatelessWidget {
  // Creates an [App].
  const App({super.key});

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
