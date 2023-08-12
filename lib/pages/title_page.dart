import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<bool> isSelected = <bool>[false, true];
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
                  context.go('/exercise');
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