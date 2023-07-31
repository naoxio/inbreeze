import 'package:go_router/go_router.dart';

import 'pages/tutorial_page.dart';
import 'pages/title_page.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => TitlePage(),
    ),
    GoRoute(
      path: '/guide/:page',
      builder: (context, state) => TutorialPage(page: state.pathParameters['page']!),
    ),
  ],
);
