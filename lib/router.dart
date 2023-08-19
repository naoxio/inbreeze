import 'package:go_router/go_router.dart';

import 'pages/title_page.dart';
import 'pages/guide_page.dart';
import 'pages/exercise_page.dart';
import 'pages/settings_page.dart';
import 'pages/splash_page.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => TitlePage(),
    ),
    GoRoute(
      path: '/guide/:page',
      builder: (context, state) => TutorialPage(page: state.pathParameters['page']!),
    ),
    GoRoute(
      path: '/exercise/:page',
      builder: (context, state) => ExercisePage(page: state.pathParameters['page']!),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsPage(),
    ),
  ],
);
