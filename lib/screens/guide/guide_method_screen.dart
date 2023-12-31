import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:localization/localization.dart'; 

class GuideMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleText: 'guide_method_title'.i18n(),
      backButtonText: 'back_button'.i18n(),
      backButtonPressed: () {
        context.go('/guide/welcome');
      },
      forwardButtonText: 'next_button'.i18n(),
      forwardButtonPressed: () {
        context.go('/guide/step1');
      },
      column: Column(
        children: [
          Text(
            'guide_method_intro'.i18n(),
            style: TextStyle(
              fontSize: 22.0,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'guide_method_steps'.i18n(),
            style: BreezeStyle.body,
          ),
          SizedBox(height: 15),
          Text(
            'guide_method_personalize'.i18n(),
            style: BreezeStyle.body,
          ),
        ],
      ),
    );
  }
}
