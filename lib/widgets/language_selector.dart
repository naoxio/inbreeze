import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';

class LanguageSelector extends StatefulWidget {
  final Function(String) onLanguageChanged;

  const LanguageSelector({super.key, required this.onLanguageChanged});

  @override
  LanguageSelectorState createState() => LanguageSelectorState();
}
class LanguageSelectorState extends State<LanguageSelector> {
  String selectedLanguage = 'en';  // Default to English
  final Map<String, String> languageOptions = {
    'en': 'English',
    'de': 'Deutsch',
    'fr': 'Français',
    'es': 'Español',
    'it': 'Italiano',
    'id': 'Bahasa Indonesia',
    'zh': '普通话',
    'ru': 'Русский',
  };

  @override
  void initState() {
    super.initState();
    _initializeLanguagePreference();
  }

  Future<void> _initializeLanguagePreference() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      String languagePreference = await userProvider.getLanguagePreference();
       
      if (!languageOptions.containsKey(languagePreference)) {
        // If the saved preference is invalid, reset to English
        languagePreference = 'en';
        await userProvider.setLanguagePreference('en');
      }


      setState(() {
        selectedLanguage = languagePreference.isNotEmpty ? languagePreference : 'en';
      });
    } catch (e) {
      print('Error fetching language preference: $e');
      setState(() {
        selectedLanguage = 'en';  // Set to default if there's an error
      });
    }
  }

  void setLanguage(String? languageCode) async {
    if (languageCode == null) return;
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.setLanguagePreference(languageCode);
      setState(() {
        selectedLanguage = languageCode;
      });
      widget.onLanguageChanged(languageCode);
    } catch (e) {
      print('Error setting language preference: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,
      items: languageOptions.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: setLanguage,
    );
  }
}