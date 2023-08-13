import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inner_breeze/components/breathing_circle.dart';
import 'shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class Step1Page extends StatefulWidget {
  Step1Page({super.key});

  @override
  State<Step1Page> createState() => _Step1PageState();
}


class _Step1PageState extends State<Step1Page> {
  int tempo = 2;
  int round = 1;
  int volume = 80;
  int maxBreaths = 30;
  int breathsDone = 1;

  Timer? breathCycleTimer;
  Duration get _breathCycleDuration => Duration(milliseconds: 2860 - (tempo * 542).toInt()) * 2;

  @override
  void initState() {
    super.initState();

    // Start the breath counting timer
    _loadMaxBreathsFromPreferences();
    startBreathCounting();
  }

  Future<void> _loadMaxBreathsFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maxBreaths = prefs.getInt('breaths') ?? 30;
    });
  }

  void _navigateToNextExercise() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step2');
    });
  }

  void startBreathCounting() {
    breathCycleTimer = Timer.periodic(_breathCycleDuration, (timer) {
      setState(() {
        breathsDone++;
      });
      if (breathsDone > 1) {
         timer.cancel();
        _navigateToNextExercise();
      }
      if (breathsDone >= maxBreaths) {
        timer.cancel();
        _navigateToNextExercise();
        // Do any additional logic when maxBreaths is reached.
      }
    });
  }


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
              AnimatedBreathingCircle(
                tempo: tempo,
                volume: volume,
                breathsDone: breathsDone
              ),
              SizedBox(height: 200),
              StopSessionButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    breathCycleTimer?.cancel();

    super.dispose();
  }
}