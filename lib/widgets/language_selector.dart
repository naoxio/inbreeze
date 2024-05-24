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
  String? selectedLanguage;
  final Map<String, String> languageOptions = {
    'en': 'English',
    'de': 'Deutsch',
    'es': 'Español',
    'fr': 'Français',
    'it': 'Italiano',
    'id': 'Bahasa Indonesia'
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
      setState(() {
        selectedLanguage = languagePreference;
      });
    } catch (e) {
      // Handle errors or set a default language if necessary
      print('Error fetching language preference: $e');
    }
  }

  void setLanguage(String languageCode) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.setLanguagePreference(languageCode);
      setState(() {
        selectedLanguage = languageCode;
      });
      widget.onLanguageChanged(languageCode);
    } catch (e) {
      // Handle potential errors when setting the language
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
      onChanged: (value) => value != null ? setLanguage(value) : null,
    );
  }
}
