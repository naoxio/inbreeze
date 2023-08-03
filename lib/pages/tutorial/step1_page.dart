import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'page_layout.dart';
import '../../components/breathing_circle.dart';

class Step1Page extends StatefulWidget {
  @override
  State<Step1Page> createState() => _Step1PageState();
}

class _Step1PageState extends State<Step1Page> {
  List<bool> breathSpeed = [false, true, false];
  List<bool> breathAudio = [false, true];
  double _breathingTempo = 0;
  double _breathingVolume = 0;
  @override
  Widget build(BuildContext context) {
    return  PageLayout(
      buttonText: 'Continue',
      nextRoute: '/guide/step2',
      onPressed: () {
        context.go('/guide/step2');
      },
      column: Column(
        children: [
          Text(
            'Step 1: In & Out',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Fill your lungs with a full breath, starting from your belly, then your chest. \n\nAllow the breath to flow out naturally without strain, repeating this process for approximately 30 breaths.',
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

          Center(
            child: CustomPaint(
              painter: BreathingCircle(),
            ),
          ),
          SizedBox(height: 180),
          Text(
            'Tempo',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Slider(
            min: 0.0,
            max: 4.0,
            label: '${_breathingTempo.round()}',
            divisions: 4,
            value: _breathingTempo,
            onChanged: (dynamic value){
              setState(() {
                _breathingTempo = value;
              });
            },
          ),
          Text(
            'Volume',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Slider(
            min: 0.0,
            max: 100.0,
            label: '${_breathingVolume.round()}',
            divisions: 10,
            value: _breathingVolume,
            onChanged: (dynamic value){
              setState(() {
                _breathingVolume = value;
              });
            },
          ),
        ],
      ),
    );
  }
}