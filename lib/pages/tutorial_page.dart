
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Namaste',
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/tuto-01-dark.png',
                width: double.infinity,
              ),
              SizedBox(height: 10),
              Text(
                "This easy yet potent breathing technique promises profound inner peace, offering a sanctuary of serenity amidst life's hectic pace.",
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'To ensure your safety, practice either lying down or sitting in a comfortable position',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: SizedBox(
            height: 64,
            width: double.infinity,
            child: TextButton(
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
