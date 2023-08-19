import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inner_breeze/components/animated_circle.dart';
import 'shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class Step3Page extends StatefulWidget {
  Step3Page({super.key});

  @override
  State<Step3Page> createState() => _Step3PageState();
}


class _Step3PageState extends State<Step3Page> {
  int volume = 80;
  int countdown = 30;
  Duration tempoDuration = Duration(seconds: 1);
  String innerText= 'in';

  Timer? breathCycleTimer;

  @override
  void initState() {
    super.initState();
    _loadDataFromPreferences();    
    startBreathCounting();

  }
  
  Future<void> _loadDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      volume = prefs.getInt('volume') ?? 80;
    });
  }

  void _navigateToNextExercise() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step1');
    });
  }

  void startBreathCounting() {
    breathCycleTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
        if (countdown >= 25) {
          tempoDuration = Duration(seconds: 5);
          innerText = 'in';        
        }
        else if (countdown <= 10) {
          tempoDuration = Duration(seconds: 5);
          innerText = 'out';
          timer.cancel();
        }
        else {
          tempoDuration = Duration(seconds: 1);
          innerText = (countdown - 10).toString();
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
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedBreathingCircle(
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