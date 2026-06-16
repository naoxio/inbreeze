import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/widgets/centered_max_width_widget.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router/router.dart';

const String title = 'Inner Breeze';
final GlobalKey<AppState> appKey = GlobalKey();

void run(Locale initialLocale) {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: App(key: appKey, initialLocale: initialLocale),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalJsonLocalization.delegate.directories = ['lib/i18n'];

  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('languagePreference') ?? 'en';
  run(Locale(languageCode));
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
  const App({required this.initialLocale, super.key});

  final Locale initialLocale;

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.initialLocale;
    unawaited(initializeLocale());
  }

  Future<void> initializeLocale() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String languageCode = await userProvider.getLanguagePreference();
    if (!mounted) {
      return;
    }

    setState(() {
      _currentLocale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        LocalJsonLocalization.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('pl', 'PL'),
        Locale('it', 'IT'),
        Locale('id', 'ID'),
        Locale('ru', 'RU'),
        Locale('zh', 'CN'),
      ],
      locale: _currentLocale,
      title: title,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        var backgroundColor = Theme.of(context).colorScheme.surface;

        return Container(
          color: backgroundColor,
          child: CenteredMaxWidthWidget(child: child!),
        );
      },
    );
  }
}
