import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'guide_router.dart';
import 'exercise_router.dart';
import 'package:inner_breeze/screens/title_screen.dart';
import 'package:inner_breeze/screens/settings_screen.dart';
import 'package:inner_breeze/screens/splash_screen.dart';
import 'package:inner_breeze/screens/results_screen.dart';
import 'package:inner_breeze/screens/progress_screen.dart';
import 'package:inner_breeze/screens/breathing_settings_screen.dart';
import 'package:inner_breeze/widgets/migration_handler.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MigrationWrapper(child: SplashScreen()),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => MigrationWrapper(child: TitleScreen()),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => MigrationWrapper(child: ProgressScreen()),
    ),
    GoRoute(
      path: '/guide/:page',
      builder: (context, state) => MigrationWrapper(
        child: GuideRouter(page: state.pathParameters['page']!),
      ),
    ),
    GoRoute(
      path: '/exercise/:page',
      builder: (context, state) => MigrationWrapper(
        child: ExerciseRouter(page: state.pathParameters['page']!),
      ),
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) => MigrationWrapper(child: ResultsScreen()),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => MigrationWrapper(child: SettingsScreen()),
    ),
    GoRoute(
      path: '/breathing',
      builder: (context, state) =>
          MigrationWrapper(child: BreathingSettingsScreen()),
    ),
  ],
);

class MigrationWrapper extends StatelessWidget {
  final Widget child;

  const MigrationWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        MigrationHandler(),
      ],
    );
  }
}
