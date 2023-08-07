import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'page_layout.dart';

class Step2Page extends StatefulWidget {
  @override
  State<Step2Page> createState() => _Step2PageState();
}

class _Step2PageState extends State<Step2Page> {
  List<bool> breathSpeed = [false, true, false];
  List<bool> breathAudio = [false, true];
  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      buttonText: 'Continue',
      nextRoute: '/guide/step3',
      onPressed: () {
        context.go('/guide/step3');
      },
      column: Column(
        children: [
          Text(
            'Step 2: Exhale, hold your breath',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text('''
Exhale normally and hold your breath.
The time of your hold will increase with more practice and with each round.
The circle in the middle indicates how long you have held your breath and the last breath hold length.

Release when you sense the urge to breathe, avoid overextending.
Your body signals when it is time to breathe.''',
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