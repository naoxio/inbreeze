import 'package:flutter/material.dart';
import 'package:inner_breeze/components/breathing_circle.dart';
import 'package:go_router/go_router.dart';


class ExercisePage extends StatefulWidget {
  ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

void _showExitConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Stop Session'),
        content: Text('Are you sure you want to end the ession?'), // Reworded as per your request
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () {
                  // Logic to stop the session goes here
                  Navigator.of(context).pop(); // Close the dialog
                  context.go('/');

                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                ),
                child: Text(
                  'Stop Session',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Just close the dialog
                },
                child: Text('Continue Session'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
class _ExercisePageState extends State<ExercisePage> {
  var tempo = 2.0;
  var round = 1;
  var volume = 80.0;

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
              AnimatedBreathingCircle(tempo: tempo, volume: volume),
              SizedBox(height: 200),
              SizedBox(
                height: 52,
                child: TextButton(
                  onPressed: () => _showExitConfirmationDialog(context),
                  child:
                    Text(
                      'Stop Session',
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
              
                    )
                    ,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}