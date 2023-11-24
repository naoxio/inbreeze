import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/widgets/stop_session.dart';
import 'package:inner_breeze/widgets/stopwatch.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ExerciseStep2 extends StatefulWidget {
  ExerciseStep2({super.key});

  @override
  State<ExerciseStep2> createState() => _ExerciseStep2State();
}

class _ExerciseStep2State extends State<ExerciseStep2> {
  Duration duration = Duration(seconds: 0);
  late Timer timer;
  int rounds = 1;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (Timer t) {
      setState(() {
        duration = duration + Duration(milliseconds: 10);
        print(duration);
      });
    });
    _loadDataFromPreferences();
  }

  Future<void> _loadDataFromPreferences() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userPreferences = await userProvider.loadUserPreferences(['breaths', 'tempo', 'volume', 'sessionId']);
    final sessionData = await userProvider.loadSessionData(['rounds']); 

    int tempo = userPreferences.tempo;
    duration = Duration(milliseconds: tempo);

    setState(() {
      rounds = sessionData!.rounds.length;
    });
  }
  
  void _onStopSessionPressed() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.saveSessionData({'rounds': {rounds + 1: duration}});
  }


  void _navigateToNextExercise() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onStopSessionPressed();
      context.go('/exercise/step3');
    });
  }


  @override
  void dispose() {
    timer.cancel(); 
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
                    'Finish Hold',
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
            ],
          ),
        ),
      ),
    );
  }
}

