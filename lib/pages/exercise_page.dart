import 'package:flutter/material.dart';
import 'package:inner_breeze/components/breathing_circle.dart';


class ExercisePage extends StatefulWidget {
  ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  var tempo = 2.0;
  var round = 1;
  var volume = 80.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.0),

        child: Center(
          
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
              AnimatedBreathingCircle(tempo: tempo, volume: volume),
              SizedBox(height: 200),
              TextButton(
                onPressed: () => {},
                child:
                  Text(
                    'Stop Session',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  )
                  ,
              )
            ],
          ),
        ),
      ),
    );
  }
}