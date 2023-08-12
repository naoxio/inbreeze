import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'page_layout.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      backButtonText: 'Skip',
      backButtonPressed: () {
        context.go('/');
      },
      forwardButtonText: 'Next',
      forwardButtonPressed: () {
        context.go('/guide/method');
      },
      column: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            width: 320,
            child: ClipOval(
              child: Image.asset(
                'assets/images/angel.png',
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Namaste',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),

          Text(
            "This easy yet potent breathing technique promises profound inner peace, offering a sanctuary of serenity amidst life's hectic pace.",
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'To ensure your safety, practice either lying down or sitting in a comfortable position.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          
        ],
      ),
    );
  }
}