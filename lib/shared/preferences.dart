import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> markTutorialAsComplete() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('tutorialComplete', true);
}

Future<void> checkUniqueId(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uniqueId = prefs.getString('uniqueId');
  if (uniqueId == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/exercise/step1');
    });
  }
}
