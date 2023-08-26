import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  

  Future<bool> _checkTutorialCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tutorialComplete') ?? false;
  }

  @override
  void initState() {
    super.initState();
    _checkTutorialCompletion().then((isComplete) {
      if (isComplete) {
        context.go('/home');
      } else {
        context.go('/guide/welcome');
      }
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), 
    );
  }
}
