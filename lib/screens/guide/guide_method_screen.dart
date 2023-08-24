import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../layouts/guide_page_layout.dart';

class GuideMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      backButtonText: 'Back',
      backButtonPressed: () {
        context.go('/guide/welcome');
      },
      forwardButtonText: 'Next',
      forwardButtonPressed: () {
        context.go('/guide/step1');
      },
      column: Column(
        children: [
          Text(
            'Method',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Simply follow 4 steps:',
            style: TextStyle(
              fontSize: 22.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15),
          Text('''
1. Inhale and exhale rhythmically for 30 breaths.
2. Exhale and hold your breath.
3. Inhale deeply and hold for 15 seconds.
4. Exhale and repeat step 1

Do 3-10 rounds of the process.
            ''',
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'The next pages will let you personalize your experience.',
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