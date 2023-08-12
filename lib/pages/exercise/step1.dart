import 'package:flutter/material.dart';
import 'package:inner_breeze/components/breathing_circle.dart';
import 'shared.dart';

class Step1Page extends StatefulWidget {
  Step1Page({super.key});

  @override
  State<Step1Page> createState() => _Step1PageState();
}

class _Step1PageState extends State<Step1Page> {
  int tempo = 2;
  int round = 1;
  int volume = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Round: $round',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedBreathingCircle(tempo: tempo, volume: volume, isReal: true),
              SizedBox(height: 200),
              SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: () => showExitConfirmationDialog(context),
                  child: Text(
                    'Stop Session',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}