import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/widgets/stopwatch.dart';

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
    // Start the timer to increase the duration every second
    timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      setState(() {
        duration = duration + Duration(milliseconds: 1);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      backButtonText: 'Back',
      backButtonPressed: () {
        context.go('/guide/step1');
      },
      forwardButtonText: 'Continue',
      forwardButtonPressed: () {
        context.go('/guide/step3');
      },
      column: Column(
        children: [
          Text(
            'Step 2: Exhale & hold',
            style: BreezeStyle.header,
          ),
          SizedBox(height: 20),
          Text('''
Exhale normally and hold your breath.

The time of your hold will increase with more practice and with each round.

The circle in the middle indicates how long you have held your breath and the last breath hold length.

Release when you sense the urge to breathe, avoid overextending. Your body signals when it is time to breathe.''',
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