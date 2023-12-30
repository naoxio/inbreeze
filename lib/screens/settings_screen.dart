import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
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
import 'package:intl/intl.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  bool _screenAlwaysOn = true;

  String _latestVersionTag = '';
  bool _isNewVersionAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadScreenAlwaysOnPreference();
    _checkForUpdates();
  }

  Future<String> _fetchLatestVersion() async {
    const String url = 'https://api.github.com/repos/naoxio/inner_breeze/releases/latest';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      _latestVersionTag = jsonResponse['tag_name']; // Store the latest version tag
      return jsonResponse['tag_name'];
    } else {
      throw Exception('Failed to fetch latest version from GitHub');
    }
  }

  int _compareVersion(String v1, String v2) {
    List<int> v1Parts = v1.split('.').map(int.parse).toList();
    List<int> v2Parts = v2.split('.').map(int.parse).toList();

    for (int i = 0; i < v1Parts.length; i++) {
      if (i >= v2Parts.length || v1Parts[i] > v2Parts[i]) {
        return 1;
      } else if (v1Parts[i] < v2Parts[i]) {
        return -1;
      }
    }
    return 0;
  }

  Future<void> _checkForUpdates() async {
    try {
      final currentVersion = await _getAppVersion();
      final latestVersion = await _fetchLatestVersion();

      if (_compareVersion(latestVersion, currentVersion) > 0) {
        setState(() {
          _isNewVersionAvailable = true;
          _latestVersionTag = latestVersion;
        });
      }
    } catch (e) {
      // Handle errors or show error notification
    }
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

  Future<void> _importData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      try {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString);

        await userProvider.importData(data);

        _showSnackBar("Data imported successfully!");
      } catch (e) {
        _showSnackBar("Error importing data: $e");
      }
    } else {
      _showSnackBar("Import cancelled");
    }
  }
  Future<void> _exportData() async {
    final DocumentFileSavePlus fileSaver = DocumentFileSavePlus();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final data = await userProvider.getAllData();
    final jsonString = jsonEncode(data);

    try {
      String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String fileName = 'InnerBreeze_$formattedDate.json';
      Uint8List textBytes = Uint8List.fromList(jsonString.codeUnits);
      await fileSaver.saveFile(textBytes, fileName, "application/json");
      _showSnackBar("Data exported successfully as $fileName");
    } catch (e) {
      _showSnackBar("Error exporting data: $e");
    }
  }

  Future<String> _getAppVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
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
                 Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('Data Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: _exportData,
                      child: const Text("Export Data"),
                    ),
                    OutlinedButton(
                      onPressed: _importData,
                      child: const Text("Import Data"),
                    ),
                  ],
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
                    _buildIconLink(Icons.web, 'Website', 'https://inner-breeze.app/'),
                    _buildIconLink('assets/icons/github.svg', 'GitHub', 'https://github.com/naoxio'),
                    _buildIconLink('assets/icons/telegram.svg', 'Telegram', 'https://t.me/naoxio'),
                    _buildIconLink('assets/icons/twitter.svg', 'X Page', 'https://x.com/naox_io'),
                    _buildIconLink(Icons.monetization_on, 'Donate', 'https://coindrop.to/naox'),
                  ],
                ),
                SizedBox(height: 40),
                FutureBuilder<String>(
                  future: _getAppVersion(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    List<Widget> versionWidgets = [];
                    if (snapshot.hasData) {
                      versionWidgets.add(Text('App Version: ${snapshot.data}'));
                      if (_isNewVersionAvailable) {
                        versionWidgets.add(Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('New version available: $_latestVersionTag'),
                        ));
                        versionWidgets.add(TextButton(
                          onPressed: () {
                            launchUrl(Uri.parse('https://github.com/naoxio/inner_breeze/releases/tag/$_latestVersionTag'));
                          },
                          child: Text('Update'),
                        ));
                      }
                    } else if (snapshot.hasError) {
                      versionWidgets.add(Text('Error: ${snapshot.error}'));
                    } else {
                      versionWidgets.add(CircularProgressIndicator());
                    }
                    return Column(children: versionWidgets);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => launchUrl(Uri.parse('https://naox.io')),
                        child: Text('NaoX', style: TextStyle(color: Colors.teal)),
                      ),
                      Text('© 2024'),
                      TextButton(
                        onPressed: () => launchUrl(Uri.parse('https://inner-breeze.app/privacy-policy')),
                        child: Text('Privacy Policy', style: TextStyle(color: Colors.teal)),
                      ),
                    ],
                  ),
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
