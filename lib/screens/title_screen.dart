import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TitleScreen extends StatefulWidget {


  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {

  @override
  void initState() {
    super.initState();
  }
  
  void _navigateToExercise() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('rounds', 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step1');
    });
  }

  @override
  Widget build(BuildContext context) {

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
                'Inner Breeze',
                style: BreezeStyle.header,
              ),
              SizedBox(height: 32),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(180, 60),
                ),
                child: Text(
                  "Start",
                  style: BreezeStyle.bodyBig,
                ),
                onPressed: () {
                  _navigateToExercise();
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