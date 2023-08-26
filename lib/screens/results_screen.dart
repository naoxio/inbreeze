import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsScreen extends StatefulWidget {
  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int rounds = 1;

  @override
  void initState() {
    super.initState();

    // Start the breath counting timer
    _loadDataFromPreferences();

  }

  Future<void> _loadDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rounds = prefs.getInt('rounds') ?? 0;
      if (rounds > 0) rounds -= 1;
      if (rounds == 0) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Results',
                style: BreezeStyle.header,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Rounds Completed: $rounds',
              style: BreezeStyle.bodyBig,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: 52,
          child: TextButton(
            onPressed: () {
              context.go('/home');
            },
            child: Text('Close'),
          ),
        ),
      ),
    );
  }
}