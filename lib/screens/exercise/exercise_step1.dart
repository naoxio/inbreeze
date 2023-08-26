import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/widgets/animated_circle.dart';
import 'package:inner_breeze/widgets/stop_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class ExerciseStep1 extends StatefulWidget {
  ExerciseStep1({super.key});

  @override
  State<ExerciseStep1> createState() => _ExerciseStep1State();
}


class _ExerciseStep1State extends State<ExerciseStep1> {
  int rounds = 1;
  int volume = 80;
  int maxBreaths = 30;
  int breathsDone = -5;

  Timer? breathCycleTimer;
  Duration tempoDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();

    // Start the breath counting timer
    _loadDataFromPreferences();

    startBreathCounting();
  }

  Future<void> _loadDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maxBreaths = prefs.getInt('breaths') ?? 30;
      int tempo = prefs.getInt('tempo') ?? 1668;
      rounds = prefs.getInt('rounds') ?? 0;
      if (rounds != 0) {
        breathsDone = 1;
      }
      tempoDuration = Duration(milliseconds: tempo);
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
            startBreathCounting();
          }
        });
      });
    } else {
      breathCycleTimer = Timer.periodic(tempoDuration, (timer) {
        setState(() {
          breathsDone = timer.tick ~/ 2 + 1;
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
                breathsDone < 0 ? 'Get Ready' : 'Round: ${rounds + 1}',
                style: BreezeStyle.header
              ),
              AnimatedCircle(
                tempoDuration: tempoDuration,
                volume: volume,
                innerText: (breathsDone > maxBreaths ? maxBreaths : breathsDone).toString(),
                controlCallback: () {
                  // Your logic here to decide what control to return
                  if (breathsDone > 0) {
                    return 'repeat';
                  }
                  else {
                    return 'stop';
                  }
                },
              ),
              SizedBox(height: 200),
              StopSessionButton(),
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

  @override
  void dispose() {
    breathCycleTimer?.cancel();

    super.dispose();
  }
}