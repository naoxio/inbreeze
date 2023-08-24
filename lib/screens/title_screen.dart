import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';

class TitleScreen extends StatelessWidget {
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