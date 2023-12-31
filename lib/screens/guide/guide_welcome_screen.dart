import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

class GuideWelcomeScreen extends StatefulWidget {
  @override
  State<GuideWelcomeScreen> createState() => _GuideWelcomeScreenState();
}

void _skipTutorial(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  await userProvider.markTutorialAsComplete();
}

class _GuideWelcomeScreenState extends State<GuideWelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      titleText: 'guide_welcome_title'.i18n(),
      backButtonText: 'skip_button'.i18n(),
      backButtonPressed: () async {
        _skipTutorial(context);
        context.go('/home');
      },
      forwardButtonText: 'next_button'.i18n(),
      forwardButtonPressed: () {
        context.go('/guide/method');
      },
      column: Column(
        children: [
          SizedBox(
            width: 320,
            child: ClipOval(
              child: Image.asset(
                'assets/images/angel.jpg',
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'guide_welcome_description'.i18n(),
            style: BreezeStyle.body,
          ),
          SizedBox(height: 15),
          Text(
            'safety_instruction'.i18n(),
            style: BreezeStyle.body,
          ),
        ],
      ),
    );
  }
}
