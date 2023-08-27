import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopSessionButton extends StatefulWidget {
  final VoidCallback? onStopSessionPressed;

  const StopSessionButton({
    this.onStopSessionPressed,
    super.key,
  });

  @override
  State<StopSessionButton> createState() => _StopSessionButtonState();
}

class _StopSessionButtonState extends State<StopSessionButton> {
  int _rounds = 1;

  @override
  void initState() {
    super.initState();
    _loadDataFromPreferences();
  }

  Future<void> _loadDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rounds = prefs.getInt('rounds') ?? 0;
    });
  }

  void _navigateToResults() {
      Navigator.of(context).pop();
      print(_rounds);

      if (widget.onStopSessionPressed != null) {
        widget.onStopSessionPressed!();
      }
      else if (_rounds == 0) {
        context.go('/home');
        return;
      }
      context.go('/results');

  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stop Session'),
          content: Text('Are you sure you want to end the session?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _navigateToResults();
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
                    Navigator.of(context).pop();
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
