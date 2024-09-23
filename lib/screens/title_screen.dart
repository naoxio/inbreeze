import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' if (dart.library.html) 'dart:html' as html;

bool isOldDomain() {
  if (kIsWeb) {
    try {
      final currentUrl = html.window.location.href;
      return currentUrl.contains('web.inner-breeze.app');
    } catch (e) {
      print('Error checking domain: $e');
      return false;
    }
  }
  return false;
}

class MigrationInstructionsModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Data Migration Instructions'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('To migrate your data to the new version:'),
            SizedBox(height: 10),
            Text('1. Go to Settings'),
            Text('2. Tap on "Export Data"'),
            Text('3. Save the exported file'),
            Text('4. Open the new version of the app at:'),
            Text('https://v1.inbreeze.xyz', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('5. In the new version, go to Settings'),
            Text('6. Tap on "Import Data"'),
            Text('7. Select the file you exported from this version'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Got it'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}


class MigrationBanner extends StatelessWidget {
  final VoidCallback onTap;

  const MigrationBanner({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Color(0xFFD35400), // Dark orange color
        child: Text(
          'Click here for migration instructions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


class TitleScreen extends StatefulWidget {
  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  void _navigateToExercise() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.startNewSession();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step1');
    });
  }

  void _showMigrationInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MigrationInstructionsModal();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (isOldDomain()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showMigrationInstructions();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (isOldDomain()) MigrationBanner(onTap: _showMigrationInstructions),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    SizedBox(
                      width: 256,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'Inner Breeze',
                      style: BreezeStyle.header,
                    ),
                    SizedBox(height: 32),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(180, 60),
                      ),
                      child: Text(
                        "start_button".i18n(),
                        style: BreezeStyle.bodyBig,
                      ),
                      onPressed: _navigateToExercise,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BreezeBottomNav(),
    );
  }
}