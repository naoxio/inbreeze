import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:inner_breeze/widgets/breathing_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
              
              // Breathing Configuration Section
              Text('Breathing Configuration', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              BreathingConfiguration(),
              SizedBox(height: 30),

              // General Settings Section
              Text('General Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
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
              ),
              // Links Section
              SizedBox(height: 40),
              Text('Connect & Support', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              _buildLink('Organization Website', 'https://naox.io/'),
              _buildLink('Telegram Community', 'https://t.me/naoxio'),
              _buildLink('GitHub Page', 'https://github.com/naoxio'),
              _buildLink('Gitea Page', 'https://git.naox.io/NaoX'),
              _buildLink('Twitter Page', 'https://x.com/naox_io'),
              _buildLink('Coindrop for Donations', 'https://coindrop.to/naox'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BreezeBottomNav(),
    );
  }

  Widget _buildLink(String title, String url) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => launch(url),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.teal,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
