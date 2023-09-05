import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

Future<void> resetData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
              Text('Settings', style: BreezeStyle.header),
              SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(140, 50),
                ),
                child: Text(
                  "Tutorial",
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  context.go('/guide/welcome');
                },
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: resetData,
                child: Text("Reset Data"),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BreezeBottomNav(),
    );
    
  }
}