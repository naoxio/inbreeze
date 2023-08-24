import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20), // Added SizedBox
              Text(
                'Session Summary',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: 52,
          child: TextButton(
            onPressed: () {
              // Close logic or navigation logic goes here.
              // For instance, if you want to navigate back, you can use:
              context.go('/home');
            },
            child: Text('Close'),
          ),
        ),
      ),
    );
  }
}