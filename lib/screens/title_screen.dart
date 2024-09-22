import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/widgets/breeze_bottom_nav.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';

// Conditionally import dart:html
import 'package:universal_html/html.dart' if (dart.library.html) 'dart:html'
    as html;

import 'package:flutter/foundation.dart';

bool isOldDomain() {
  if (kIsWeb) {
    try {
      final currentUrl = html.window.location.href;
      return currentUrl.contains('web.inner-breeze.app');
    } catch (e) {
      // Handle any potential errors when accessing window.location
      print('Error checking domain: $e');
      return false;
    }
  }
  return false; // Return false for non-web platforms
}

class MigrationBanner extends StatelessWidget {
  final VoidCallback onMigrate;
  const MigrationBanner({Key? key, required this.onMigrate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Click here to migrate your data to the new domain',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: onMigrate,
            child: Text('Migrate'),
          ),
        ],
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              if (isOldDomain())
                MigrationBanner(
                  onMigrate: () {
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    final migrationUrl = userProvider.generateMigrationUrl();
                    if (kIsWeb) {
                      html.window.open(migrationUrl, '_blank');
                    } else {
                      // Handle non-web platforms (e.g., show a dialog or navigate to a new screen)
                      print('Migration not supported on this platform');
                    }
                  },
                ),
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
                onPressed: () {
                  _navigateToExercise();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BreezeBottomNav(),
    );
  }
}
