import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/providers/user_provider.dart';

class LanguageSelector extends StatefulWidget {
  final Function(String) onLanguageChanged;

  const LanguageSelector({super.key, required this.onLanguageChanged});

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String? selectedLanguage;

  final Map<String, String> languageOptions = {
    'en': 'English',
    'de': 'Deutsch',
    'es': 'Español',
    'it': 'Italiano',
  };

  @override
  void initState() {
    super.initState();
    _initializeLanguagePreference();
  }

  Future<void> _initializeLanguagePreference() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String languagePreference = await userProvider.getLanguagePreference();
    setState(() {
      selectedLanguage = languagePreference;
    });
  }

  void setLanguage(String languageCode) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.setLanguagePreference(languageCode);
    widget.onLanguageChanged(languageCode);
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
      onChanged: (value) {
        if (value != null) setLanguage(value);
      },
    );
  }
}
