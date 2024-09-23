import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';


// Conditionally import dart:html
import 'dart:async';
import 'package:universal_html/html.dart' if (dart.library.html) 'dart:html'
    as html;
class MigrationHandler extends StatefulWidget {
  final String? data;
  
  const MigrationHandler({Key? key, this.data}) : super(key: key);

  @override
  _MigrationHandlerState createState() => _MigrationHandlerState();
}

class _MigrationHandlerState extends State<MigrationHandler> {
  bool _showBanner = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _handleMigration(widget.data!);
    }
  }

  void _handleMigration(String compressedData) async {
    setState(() {
      _showBanner = true;
      _message = 'Migrating data...';
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.importCompressedData(compressedData);
      
      setState(() {
        _message = 'Data migration completed successfully!';
      });
      
      // Delay navigation to show success message
      Future.delayed(Duration(seconds: 2), () {
        context.go('/home');
      });
    } catch (e) {
      print('Error during migration: $e');
      setState(() {
        _message = 'Error during data migration: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text('Migrating data...'),
          ),
          if (_showBanner)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.orange[900],
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: SafeArea(
                  child: Text(
                    _message,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}