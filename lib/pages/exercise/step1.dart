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
  int breathsDone = -5;

  Timer? breathCycleTimer;
  Duration get _breathCycleDuration => Duration(milliseconds: 2860 - (tempo * 542).toInt()) * 2;

  @override
  void initState() {
    super.initState();

    // Start the breath counting timer
    _loadDataFromPreferences();
  
    if (round != 1) {
      breathsDone = 1;
    }
    startBreathCounting();
  }

  Future<void> _loadDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maxBreaths = prefs.getInt('breaths') ?? 30;
      tempo = prefs.getInt('tempo') ?? 2;
      volume = prefs.getInt('volume') ?? 80;
    });
  }

  void _navigateToNextExercise() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step2');
    });
  }

  void startBreathCounting() {
    if (breathsDone < 0) {
      breathCycleTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          breathsDone++;
          if (breathsDone == 0) {
            breathsDone = 1;
            timer.cancel();
            startBreathCounting();  // Restart the timer with the original duration
          }
        });
      });
    } else {
      breathCycleTimer = Timer.periodic(_breathCycleDuration, (timer) {
        setState(() {
          breathsDone++;
        });
        if (breathsDone >= maxBreaths + 1) {
          timer.cancel();
          _navigateToNextExercise();
        }
      });
    }
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
                breathsDone < 0 ? 'Get Ready' : 'Round: $round',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedBreathingCircle(
                tempo: tempo,
                volume: volume,
                innerText: (breathsDone > maxBreaths ? maxBreaths : breathsDone).toString(),
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