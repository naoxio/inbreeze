
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import 'dart:async';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Timer(Duration(seconds: 1), () => appState.changeIndex(1));
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
