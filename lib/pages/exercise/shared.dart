import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class StopSessionButton extends StatelessWidget {
  const StopSessionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextButton(
        onPressed: () => _showExitConfirmationDialog(context),
        child: Text(
          'Stop Session',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey,

          ),
        ),
      ),
    );
  }
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
                  context.go('/home');

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