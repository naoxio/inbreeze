import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';

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
                'Results',
                style: BreezeStyle.header,
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