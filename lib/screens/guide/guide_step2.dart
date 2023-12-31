import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/widgets/stopwatch.dart';
import 'package:localization/localization.dart'; 

class GuideStep2Screen extends StatefulWidget {
  @override
  State<GuideStep2Screen> createState() => _GuideStep2ScreenState();
}

class _GuideStep2ScreenState extends State<GuideStep2Screen> {
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
      titleText: 'guide_step2_title'.i18n(),
      backButtonText: 'back_button'.i18n(), 
      backButtonPressed: () {
        context.go('/guide/step1');
      },
      forwardButtonText: 'continue_button'.i18n(),
      forwardButtonPressed: () {
        context.go('/guide/step3');
      },
      column: Column(
        children: [
          Text(      
            'guide_step2_description'.i18n(),
            style: BreezeStyle.body,
          ),
          SizedBox(height: 40),
          SizedBox(
            width: 300,
            height: 200,
            child: CustomTimer(duration: duration),  
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}