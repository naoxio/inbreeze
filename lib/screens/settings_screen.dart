import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:inner_breeze/widgets/breeze_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/models/preferences.dart';


class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  bool _screenAlwaysOn = true;

  @override
  void initState() {
    super.initState();
    _loadScreenAlwaysOnPreference();
  }

  Future<void> _loadScreenAlwaysOnPreference() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final preferences = await userProvider.loadUserPreferences(['screenAlwaysOn']);
    setState(() {
      _screenAlwaysOn = preferences.screenAlwaysOn;
    });
  }

  Future<void> _updateScreenAlwaysOnPreference(bool value) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final preferences = Preferences(
      screenAlwaysOn: value,
    );
    userProvider.saveUserPreferences(preferences);

    setState(() {
      _screenAlwaysOn = value;
    });
  }

  Future<void> _resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Reset"),
          content: Text("Are you sure you want to reset all data? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Reset Data", style: TextStyle(color: Colors.red)),
              onPressed: () {
                _resetData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BreezeAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: 480,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [    
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(140, 50),
                  ),
                  child: Text(
                    "Show Tutorial",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    context.go('/guide/welcome');
                  },
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  child: Text(
                    "Breathing Circle",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {
                    context.go('/breathing');
                  },
                ),
                SizedBox(height: 20),
                SwitchListTile(
                  title: Text('Keep Screen On During Exercise'),
                  value: _screenAlwaysOn,
                  onChanged: (bool value) {
                    _updateScreenAlwaysOnPreference(value);
                  },
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _showResetConfirmation,
                  child: Text("Reset Data", style: TextStyle(color: Colors.red)),
                ),
                // Links Section
                SizedBox(height: 40),
                Text('Connect & Support', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    _buildIconLink(Icons.web, 'Website', 'https://naox.io/'),
                    _buildIconLink('assets/icons/github.svg', 'GitHub', 'https://github.com/naoxio'),
                    _buildIconLink('assets/icons/telegram.svg', 'Telegram', 'https://t.me/naoxio'),
                    _buildIconLink('assets/icons/twitter.svg', 'X Page', 'https://x.com/naox_io'),
                    _buildIconLink(Icons.monetization_on, 'Coindrop', 'https://coindrop.to/naox'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BreezeBottomNav(),
    );
  }
  Widget _buildIconLink(dynamic iconOrImagePath, String tooltip, String url) {
    return IconButton(
      icon: (iconOrImagePath is IconData) 
        ? Icon(iconOrImagePath, color: Colors.teal)
        : (iconOrImagePath.endsWith('.svg')
            ? SvgPicture.asset(iconOrImagePath, color: Colors.teal, width: 24, height: 24)
            : Image.asset(iconOrImagePath, color: Colors.teal, width: 24, height: 24)),
      tooltip: tooltip,
      onPressed: () => launchUrl(Uri.parse(url)),
    );
  }


}
