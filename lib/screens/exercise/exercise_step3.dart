import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/widgets/animated_circle.dart';
import 'package:inner_breeze/widgets/stop_session.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ExerciseStep3 extends StatefulWidget {
  ExerciseStep3({super.key});

  @override
  State<ExerciseStep3> createState() => _ExerciseStep3State();
}

class _ExerciseStep3State extends State<ExerciseStep3> {
  int volume = 80;
  int countdown = 30;
  Duration tempoDuration = Duration(seconds: 2);
  String innerText= 'in';

  Timer? breathCycleTimer;

  @override
  void initState() {
    super.initState();
    _loadDataFromPreferences().then((_) {
      startBreathCounting();
    });
  }
  
  Future<void> _loadDataFromPreferences() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final preferences = await userProvider.loadUserPreferences(['volume']);

    setState(() {
      volume = preferences.volume;
    });
  }

  void _navigateToNextExercise() async{
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step1');
    });
  }

  void startBreathCounting() {
    breathCycleTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timer.tick < 2) {
          innerText = 'in';
        } else if ( timer.tick < 17) {
          innerText = (17 - timer.tick).toString();
        } else if (timer.tick >= 17 && timer.tick <= 18) {
          innerText = 'out';
        } else {
          timer.cancel();
          _navigateToNextExercise();
        }
      });
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
                'Recovery',
                style: BreezeStyle.header,
              ),
              AnimatedCircle(
                volume: volume,
                tempoDuration: tempoDuration,
                innerText: innerText,
                controlCallback: () {
                  if (innerText == 'in') {
                    return 'forward';
                  }
                  else if (innerText == 'out') {
                    return 'reverse';
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
                ),
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