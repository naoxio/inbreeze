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
  bool _showBanner = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleMigration();
    });
  }

  void _handleMigration() async {
    if (kIsWeb) {
      try {
        final uri = Uri.parse(html.window.location.href);
        final compressedData = uri.queryParameters['data'];
        if (compressedData != null) {
          setState(() {
            _showBanner = true;
            _message = 'Migrating data...';
          });
          
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          await userProvider.importCompressedData(compressedData);
          
          setState(() {
            _message = 'Data migration completed successfully!';
          });
          
          html.window.history.pushState(null, '', '/');
          
          // Hide the banner after a delay
          Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _showBanner = false;
            });
          });
        }
      } catch (e, stackTrace) {
        print('Error during web migration: $e');
        print('Stack trace: $stackTrace');
        setState(() {
          _showBanner = true;
          _message = 'Error during data migration: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner) return SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.orange[900], // Dark orange background
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            _message,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}