import 'package:shared_preferences/shared_preferences.dart';

Future<void> markTutorialAsComplete() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('tutorialComplete', true);
}