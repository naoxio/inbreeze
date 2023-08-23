import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  Future<bool> _checkTutorialCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tutorialComplete') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkTutorialCompletion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            Future.microtask(() => context.go('/home'));
          } else {
            Future.microtask(() => context.go('/guide/welcome')); // Replace with your default route
          }
          return Container(); // Return an empty container after deciding navigation
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()), // Display a loading indicator while checking
        );
      },
    );
  }
}
