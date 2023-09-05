import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/widgets/breathing_configuration.dart';

class GuideStep1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      backButtonText: 'Back',
      backButtonPressed: () {
        context.go('/guide/method');
      },
      forwardButtonText: 'Continue',
      forwardButtonPressed: () {
        context.go('/guide/step2');
      },
      column: Column(
        children: [
          Text(
            'Step 1: In & Out',
            style: BreezeStyle.header
          ),
          SizedBox(height: 20),
          Text('''
Fill your lungs with a full breath, starting from your belly, then your chest.

Allow the breath to flow out naturally without strain.

Repeat this for about 20-40 breaths at a steady pace.''',
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Breathing Circle',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          BreathingConfiguration(),
        ],
      ),
    );
  }
}
