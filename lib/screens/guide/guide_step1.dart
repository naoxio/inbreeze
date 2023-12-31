import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/widgets/breathing_configuration.dart';
import 'package:localization/localization.dart'; // Import localization

class GuideStep1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleText: 'guide_step1_title'.i18n(),
      backButtonText: 'back_button'.i18n(),
      backButtonPressed: () {
        context.go('/guide/method');
      },
      forwardButtonText: 'continue_button'.i18n(),
      forwardButtonPressed: () {
        context.go('/guide/step2');
      },
      column: Column(
        children: [
          Text(
            'guide_step1_description'.i18n(),
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'breathing_circle'.i18n(),
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
