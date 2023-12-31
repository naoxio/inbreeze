import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

class GuideStep3Screen extends StatefulWidget {
  @override
  State<GuideStep3Screen> createState() => _GuideStep3ScreenState();
}

void _finishTutorial(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  await userProvider.markTutorialAsComplete();
}

class _GuideStep3ScreenState extends State<GuideStep3Screen> {
  Duration duration = Duration(seconds: 0);
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      setState(() {
        duration = duration + Duration(milliseconds: 1);
      });
    });
  }


  @override
  void dispose() {
    timer.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      titleText: 'guide_step3_title'.i18n(),
      backButtonText: 'back_button'.i18n(),
      backButtonPressed: () {
        context.go('/guide/step2');
      },
      forwardButtonText: 'finish_button'.i18n(),
      forwardButtonPressed: () {
        _finishTutorial(context);

        context.go('/home');
      },
      column: Column(
        children: [
          SizedBox(
            width: 320,
            child: Image.asset(
              'assets/images/begin.jpg',
              width: double.infinity,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'guide_step3_description'.i18n(),
            style: BreezeStyle.body,
          ),
       

        ],
      ),
    );
  }
}