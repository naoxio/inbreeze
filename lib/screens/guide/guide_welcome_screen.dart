import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:provider/provider.dart';

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
    return  PageLayout(
      titleText: 'Namaste',
      backButtonText: 'Skip',
      backButtonPressed: () async {
        _skipTutorial(context);
        context.go('/home');
      },
      forwardButtonText: 'Next',
      forwardButtonPressed: () {
        context.go('/guide/method');
      },
      column: Column(
        children: [
          SizedBox(
            width: 320,
            child: ClipOval(
              child: Image.asset(
                'assets/images/angel.png',
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "This easy yet potent breathing technique promises profound inner peace, offering a sanctuary of serenity amidst life's hectic pace.",
            style: BreezeStyle.body,
          ),
          SizedBox(height: 15),
          Text(
            'To ensure your safety, practice either lying down or sitting in a comfortable position.',
            style: BreezeStyle.body,
          ),
          
        ],
      ),
    );
  }
}