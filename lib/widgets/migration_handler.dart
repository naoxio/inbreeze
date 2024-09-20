import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

// Conditionally import dart:html
import 'dart:async';
import 'package:universal_html/html.dart' if (dart.library.html) 'dart:html'
    as html;

class MigrationHandler extends StatefulWidget {
  @override
  _MigrationHandlerState createState() => _MigrationHandlerState();
}

class _MigrationHandlerState extends State<MigrationHandler> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleMigration();
    });
  }

  void _handleMigration() async {
    // Check if running on the web
    if (kIsWeb) {
      try {
        final uri = Uri.parse(html.window.location.href);
        final compressedData = uri.queryParameters['data'];
        if (compressedData != null) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          await userProvider.importCompressedData(compressedData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data migration completed successfully!')),
          );
          html.window.history.pushState(null, '', '/');
        }
      } catch (e) {
        print('Error during web migration: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during data migration')),
        );
      }
    } else {
      // Handle non-web scenarios, if necessary
      print('Migration logic is only for web.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink(); // Empty widget
  }
}
