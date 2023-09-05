import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StopSessionButton extends StatefulWidget {
  final VoidCallback? onStopSessionPressed;

  const StopSessionButton({
    this.onStopSessionPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<StopSessionButton> createState() => _StopSessionButtonState();
}

class _StopSessionButtonState extends State<StopSessionButton> {
  int _rounds = 1;

  @override
  void initState() {
    super.initState();
    _loadDataFromProvider();
    print('stop session');
    print(_rounds);
  }

  Future<void> _loadDataFromProvider() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final sessionData = await userProvider.loadSessionData(['rounds']);
    setState(() {
      _rounds = sessionData['rounds'] ?? 0;
    });
  }

  void _navigateToResults() {
      Navigator.of(context).pop();

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
