import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TitlePage extends StatefulWidget {
  const TitlePage({super.key});

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  bool _shouldNavigate = false;

  @override
  void initState() {
    super.initState();
    isFirstTimeOpeningApp();
  }
  
  Future<void> isFirstTimeOpeningApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasCompletedTutorial = prefs.getBool('tutorialComplete') ?? false;

    if (!hasCompletedTutorial) {
      setState(() {
        _shouldNavigate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   if (_shouldNavigate) {
      // Navigate and then reset the _shouldNavigate flag to prevent repeated navigation
      _shouldNavigate = false;
      context.go('/guide/welcome');
    }
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(
                width: 256,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'InX: Inner Breeze',
                style: TextStyle(fontSize: 32.0),
              ),
              SizedBox(height: 32),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(180, 60),
                ),
                child: Text(
                  "Start",
                  style: TextStyle(fontSize: 24.0),
                ),
                onPressed: () {
                  context.go('/exercise/step1');
                },
              ),
              SizedBox(height: 20),
              TextButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(120, 50),
                ),
                child: Text(
                  "Settings",
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () {
                  context.go('/settings');
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}