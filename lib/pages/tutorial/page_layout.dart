

import 'package:flutter/material.dart';

class PageLayout extends StatelessWidget {
  final String buttonText;
  final String nextRoute;
  final VoidCallback onPressed;
  final Widget column;

  PageLayout({
    required this.column,
    required this.buttonText,
    required this.nextRoute,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 420,
              child: column
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: 64,
          width: double.infinity,
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

