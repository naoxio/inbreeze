import 'dart:async'; // Required for the Timer
import 'package:flutter/material.dart';
import 'shared.dart';
import '../../components/stopwatch.dart';
import 'package:go_router/go_router.dart';

class Step2Page extends StatefulWidget {
  Step2Page({super.key});

  @override
  State<Step2Page> createState() => _Step2PageState();
}

class _Step2PageState extends State<Step2Page> {
  Duration duration = Duration(seconds: 0);
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Start the timer to increase the duration every second
    timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      setState(() {
        duration = duration + Duration(milliseconds: 1);
      });
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
                    context.go('/exercise/step3');
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
              StopSessionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

