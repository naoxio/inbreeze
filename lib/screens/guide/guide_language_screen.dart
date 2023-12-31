import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inner_breeze/layouts/guide_page_layout.dart';
import 'package:inner_breeze/shared/breeze_style.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguage;
  bool isLoading = true;
  
  final Map<String, String> languageOptions = {
    'en': 'English',
    'es': 'Español',
    'de': 'Deutsch',
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
      isLoading = false;
    });
  }
    
  void setLanguage(String languageCode) async {
    setState(() {
      isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.setLanguagePreference(languageCode);

    await Future.delayed(Duration(milliseconds: 50));

    setState(() {
      isLoading = false;
      selectedLanguage = languageCode; 
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 128.0,
          height: 128.0,
          child: CircularProgressIndicator(),
        ),
      );
    }

    return PageLayout(
      titleText: 'language_selection_title'.i18n(),
      forwardButtonText: 'continue_button'.i18n(),
      forwardButtonPressed: () {
        context.go('/guide/welcome');
      },
      column: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: DropdownButton<String>(
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
            ),
          ),
          SizedBox(height: 20),
          Text(
            'language_instruction'.i18n(), // Using i18n
            style: BreezeStyle.body,
          ),
        ],
      ),
    );
  }
}