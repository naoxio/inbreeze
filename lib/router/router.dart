import 'package:go_router/go_router.dart';

import 'guide_router.dart';
import 'exercise_router.dart';
import 'package:inner_breeze/screens/title_screen.dart';
import 'package:inner_breeze/screens/settings_screen.dart';
import 'package:inner_breeze/screens/splash_screen.dart';
import 'package:inner_breeze/screens/results_screen.dart';
import 'package:inner_breeze/screens/progress_screen.dart';
import 'package:inner_breeze/screens/breathing_settings_screen.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => TitleScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => ProgressScreen(),
    ),
    GoRoute(
      path: '/guide/:page',
      builder: (context, state) => GuideRouter(page: state.pathParameters['page']!),
    ),
    GoRoute(
      path: '/exercise/:page',
      builder: (context, state) => ExerciseRouter(page: state.pathParameters['page']!),
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) => ResultsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
    GoRoute(
      path: '/breathing',
      builder: (context, state) => BreathingSettingsScreen(),
    ),
  ],
);
