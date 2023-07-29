import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';


class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final List<bool> isSelected = <bool>[false, true];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          ToggleButtons(
            isSelected: isSelected,
            onPressed: (int index) {
              for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = true;
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
            },
        
            children: const <Widget>[
              Icon(Icons.light_mode),
              Icon(Icons.dark_mode),
            ],
          ),
        ],
        
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
            ),
            Text(
              'InX: Inner Breeze',
              style: TextStyle(fontSize: 32.0),
            ),
            SizedBox(height: 32),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(180, 60),
              ),
              child: Text(
                "Start",
                style: TextStyle(fontSize: 24.0),
              ),
              onPressed: () {
                appState.changeIndex(1);
              },
            )
          ],
        ),
      ),
    );
  }
}