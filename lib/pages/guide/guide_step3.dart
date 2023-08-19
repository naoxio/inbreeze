import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'page_layout.dart';
import 'shared.dart';

class GuideStep3Page extends StatefulWidget {
  @override
  State<GuideStep3Page> createState() => _GuideStep3PageState();
}

void _finishTutorial(BuildContext context) async {
  await markTutorialAsComplete();
}

class _GuideStep3PageState extends State<GuideStep3Page> {
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
        context.go('/guide/step2');
      },
      forwardButtonText: 'Finish',
      forwardButtonPressed: () {
        _finishTutorial(context);

        context.go('/home');
      },
      column: Column(
        children: [
          Text(
            'Step 3: Inhale & hold',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 320,
            child: Image.asset(
              'assets/images/begin.jpg',
              width: double.infinity,
            ),
          ),
          SizedBox(height: 20),
          Text('''
Inhale fully and hold for 15 seconds.
Afterwards exhale, completing the first round.

With every round you can hold your breath longer and go deeper.''',
            style: TextStyle(
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
       

        ],
      ),
    );
  }
}