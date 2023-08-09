import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<bool> isSelected = <bool>[false, true];
    return Scaffold(
      /*appBar: AppBar(
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
        
      ),*/
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(
                width: 256,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
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
                  context.go('/guide/welcome');
                },
              ),
              SizedBox(height: 32),

            ],
          ),
        ),
      ),
    );
  }
}