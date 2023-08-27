import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inner_breeze/widgets/stop_session.dart';
import 'package:inner_breeze/widgets/stopwatch.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseStep2 extends StatefulWidget {
  ExerciseStep2({super.key});

  @override
  State<ExerciseStep2> createState() => _ExerciseStep2State();
}

class _ExerciseStep2State extends State<ExerciseStep2> {
  Duration duration = Duration(seconds: 0);
  late Timer timer;

  String? _uniqueId;
  int _rounds = 0;

  @override
  void initState() {
    super.initState();
    checkUniqueId(context);

    timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      setState(() {
        duration = duration + Duration(milliseconds: 1);
      });
    });
    _loadUniqueIdAndRound();
  }


  Future<void> _loadUniqueIdAndRound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uniqueId = prefs.getString('uniqueId');
    _rounds = prefs.getInt('rounds') ?? 0;
  }

  void _onStopSessionPressed() async {
    _rounds += 1;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('rounds', _rounds);
    final key = '$_uniqueId/$_rounds';
    prefs.setInt(key, duration.inMilliseconds);
  }

  void _navigateToNextExercise() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onStopSessionPressed();
      context.go('/exercise/step3');
    });
  }


  @override
  void dispose() {
    timer.cancel(); // Dispose the timer when the widget is removed from the tree
    super.dispose();
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
              SizedBox(
                width: 300,
                height: 300,
                child: CustomTimer(duration: duration),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: () {
                    _navigateToNextExercise();
                  },
                  child: Text(
                    'Stop Hold',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              StopSessionButton(
                onStopSessionPressed: _onStopSessionPressed,
              ),
              if (!kReleaseMode)
                TextButton(
                  child: Text('Skip'),
                  onPressed: () {
                    _navigateToNextExercise();
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

